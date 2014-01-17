Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaAQFTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 00:19:10 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:40918 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaAQFTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 00:19:07 -0500
Message-ID: <1389936047.5567.721.camel@haakon3.risingtidesystems.com>
Subject: Re: bio_integrity_verify() bug causing READ verify to be silently
 skipped
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        kmo@daterainc.com
Date: Thu, 16 Jan 2014 21:20:47 -0800
In-Reply-To: <yq1sit4zv23.fsf@sermon.lab.mkp.net>
References: <1387858826.5567.236.camel@haakon3.risingtidesystems.com>
	 <yq1sit4zv23.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-03 at 15:09 -0500, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> 
> nab> Given that bio_integrity_verify() is using bio_for_each_segment(),
> nab> the loop starts from the updated bio->bi_idx, and not a zero value,
> nab> which ends up skipping individual bio segment calls to
> nab> bi->verify_fn().
> 
> That's botched. Verify is meant to be called with the completed bytes
> before the index is tampered with.
> 
> 
> nab> The following patch changes bio_integrity_verify() to use
> nab> bio_for_each_segment_all() instead of bio_for_each_segment() to
> nab> ensure that the segment walk always starts from zero, regardless of
> nab> the current bio->bi_idx value after bio_advance().
> 
> That breaks partial completion, though. I'll take a look at Kent's
> changes...
> 

Ping..?  Any updates on a proper bugfix for this..?

--nab

