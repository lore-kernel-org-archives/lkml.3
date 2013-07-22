Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab3GVVFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:05:07 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:52453 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab3GVVFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:05:04 -0400
Message-ID: <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Mike Christie <michaelc@cs.wisc.edu>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date: Mon, 22 Jul 2013 14:10:36 -0700
In-Reply-To: <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
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
	 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 17:03 +0200, Alexander Gordeev wrote:
> On Fri, Jul 19, 2013 at 09:56:02PM -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2013-07-19 at 14:01 -0700, Nicholas A. Bellinger wrote:
> > OK, after further investigation the root cause is a actually a missing
> > bio->bio_end_io() -> bio_copy_kern_endio() -> bio_put() from the
> > blk_end_sync_rq() callback path that scsi-mq REQ_TYPE_BLOCK_PC is
> > currently using.
> 
> Yes, missing bio_copy_kern_endio() callback is exactly the reason I
> turned to blk_mq_execute_rq() initially. I should have been more
> specific on this :|
> 
> I will try Mike's and your other change, hopefully soon (sorry,
> constantly getting distracted).
> 

Np.  FYI, you'll want to use the latest commit e7827b351 HEAD from
target-pending/scsi-mq, which now has functioning scsi-generic support.

Also, your scsi_times_out patch from earlier has not been included just
yet, but that should be the only extra patch you need to apply in order
to get scsi-mq enabled libata/ata_piix running.

--nab

