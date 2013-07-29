Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3G2LuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:50:20 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:44822 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3G2LuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:50:15 -0400
Date: Mon, 29 Jul 2013 07:50:11 -0400
From: Tejun Heo <tj@kernel.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Gordeev <agordeev@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20130729115011.GC20951@mtj.dyndns.org>
References: <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
 <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
 <20130726020928.GL29296@kernel.dk>
 <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
 <1374885793.7397.1537.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374885793.7397.1537.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo,

On Fri, Jul 26, 2013 at 05:43:13PM -0700, Nicholas A. Bellinger wrote:
> Considering there can be more than a single ata_device hanging off each
> ata_port, the '*sdev = ap->link.device[0].sdev' in __ata_qc_from_tag()
> is definitely bogus, but I'm not sure how else to correlate
> blk-mq/scsi-mq per device descriptors to existing code expecting
> ata_port->qcmd[] descriptors to be shared across multiple devices..
> 
> Tejun..?

I have no idea.  Let's please just do simpler conversion and worry
about embedding qc's into scsi_cmnds later.  libata isn't a normal
SCSI driver and has a rather its own thick midlayer doing the
impedance matching inbetween && I really don't think there is too much
benefit to be reaped from embedding qc's into scsi_cmnds.

Thanks.

-- 
tejun
