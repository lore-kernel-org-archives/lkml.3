Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3GYWC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 18:02:27 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:53288 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3GYWCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 18:02:24 -0400
Message-ID: <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Mike Christie <michaelc@cs.wisc.edu>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date: Thu, 25 Jul 2013 15:08:02 -0700
In-Reply-To: <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
References: <51E83E32.9050306@cs.wisc.edu>
	 <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
	 <20130719003034.GG28005@kernel.dk>
	 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
	 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
	 <1374248000.2266.20.camel@dabdike>
	 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
	 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
	 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
	 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
	 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 12:16 +0200, Alexander Gordeev wrote:
> On Mon, Jul 22, 2013 at 02:10:36PM -0700, Nicholas A. Bellinger wrote:
> > Np.  FYI, you'll want to use the latest commit e7827b351 HEAD from
> > target-pending/scsi-mq, which now has functioning scsi-generic support.
> 
> Survives a boot, a kernel build and the build's result :)

Great.  Thanks for the feedback Alexander!

So the next step on my end is to enable -mq for ahci, and verify initial
correctness using QEMU/KVM hardware emulation.

Btw, I've been looking at enabling the SHT->cmd_size for struct
ata_queued_cmd descriptor pre-allocation, but AFAICT these descriptors
are already all pre-allocated by libata and obtained via ata_qc_new() ->
__ata_qc_from_tag() during ata_scsi_queuecmd().

So that said, with the struct request + struct scsi_cmnd pre-allocations
already provided by blk-mq -> scsi-mq code, all memory allocations
should have already been eliminated from I/O fast path.

--nab








