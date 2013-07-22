Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3GVPEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:04:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab3GVPET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:04:19 -0400
Date: Mon, 22 Jul 2013 17:03:59 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Mike Christie <michaelc@cs.wisc.edu>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
References: <20130717161909.GB21468@dhcp-26-207.brq.redhat.com>
 <1374173515.7397.948.camel@haakon3.risingtidesystems.com>
 <51E83E32.9050306@cs.wisc.edu>
 <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
 <20130719003034.GG28005@kernel.dk>
 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
 <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 09:56:02PM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2013-07-19 at 14:01 -0700, Nicholas A. Bellinger wrote:
> OK, after further investigation the root cause is a actually a missing
> bio->bio_end_io() -> bio_copy_kern_endio() -> bio_put() from the
> blk_end_sync_rq() callback path that scsi-mq REQ_TYPE_BLOCK_PC is
> currently using.

Yes, missing bio_copy_kern_endio() callback is exactly the reason I
turned to blk_mq_execute_rq() initially. I should have been more
specific on this :|

I will try Mike's and your other change, hopefully soon (sorry,
constantly getting distracted).

> Including the following patch into the scsi-mq working branch now, and
> reverting the libata dma_alignment=0x03 hack.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
