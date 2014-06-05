Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaFEOAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:00:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaFEOAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:00:15 -0400
Date: Thu, 5 Jun 2014 16:01:27 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: Re: blk-mq: bitmap tag: performance degradation?
Message-ID: <20140605140127.GA22198@dhcp-26-207.brq.redhat.com>
References: <20140604103544.GA11350@dhcp-26-207.brq.redhat.com>
 <538F2AC2.1060904@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F2AC2.1060904@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 08:18:42AM -0600, Jens Axboe wrote:
> A null_blk test is the absolute best case for percpu_ida, since
> there are enough tags and everything is localized. The above test is
> more useful for testing blk-mq than any real world application of
> the tagging.
> 
> I've done considerable testing on both 2 and 4 socket (32 and 64
> CPUs) and bitmap tagging is better in a much wider range of
> applications. This includes even high tag depth devices like nvme,
> and more normal ranges like mtip32xx and scsi-mq setups.

Just for the record: bitmap tags on a 48 CPU box with NVMe device
indeed shows almost the same performance/cache rate as the stock
kernel.


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
