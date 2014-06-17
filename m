Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbaFQO2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:28:07 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:46907 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985AbaFQO2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:28:05 -0400
Message-ID: <53A05068.4080702@acm.org>
Date: Tue, 17 Jun 2014 16:27:52 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliot <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: scsi-mq
References: <1402580946-11470-1-git-send-email-hch@lst.de>
In-Reply-To: <1402580946-11470-1-git-send-email-hch@lst.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/14 15:48, Christoph Hellwig wrote:
> Bart and Robert have helped with some very detailed measurements that they
> might be able to send in reply to this, although these usually involve
> significantly reworked low level drivers to avoid other bottle necks.

In case someone would like to see the results of the measurements I ran,
these results can be found here:
https://docs.google.com/file/d/0B1YQOreL3_FxUXFMSjhmNDBNNTg.

Two important conclusions from the data in that PDF document are as follows:
- A small but significant performance improvement for the traditional
  SCSI mid-layer (use_blk_mq=N).
- A very significant performance improvement for multithreaded
  workloads with use_blk_mq=Y. As an example, the number of I/O
  operations per second reported for the random write test increased
  with 170%. That means 2.7 times the performance
  of use_blk_mq=N.

I think this means the scsi-mq patches are ready for wider use.

Bart.
