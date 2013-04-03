Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763297Ab3DCJls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:41:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763283Ab3DCJlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:41:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <28255253.1085258.1364957623947.JavaMail.root@redhat.com>
References: <28255253.1085258.1364957623947.JavaMail.root@redhat.com> <1484037905.443048.1364884090669.JavaMail.root@redhat.com> <19926.1364924330@warthog.procyon.org.uk>
To: CAI Qian <caiqian@redhat.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: NULL pointer at kset_find_obj
Date: Wed, 03 Apr 2013 10:41:41 +0100
Message-ID: <9518.1364982101@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAI Qian <caiqian@redhat.com> wrote:

> > Can you check back earlier in the dmesg to see whether the kernel tried to
> > load the key?  -11 is presumably -EAGAIN - in which case no such key was
> > found
> > (rather than there being a cached lookup failure which is what -ENOKEY would
> > indicate).  It is possible that you encountered the key-not-yet-valid problem
> > due to your h/w clock showing a value prior to the start date on the key.
> Hmm, unsure about how to check it, but here is the full log prior the panic,
> http://people.redhat.com/qcai/stable/log.key

This bit here:

    [    2.693861] Loading module verification certificates 
    [    2.698920] X.509: Cert 8b7774b08bc4ee9637073434c10f0823f6fbe523 is not yet valid 
    [    2.706444] MODSIGN: Problem loading in-kernel X.509 certificate (-129) 

After those lines, you have indeed managed to load some modules:

    [   35.218540] Modules linked in: kvm(F+) microcode(F+) i2c_nforce2(F) edac_core(F) k8temp(F) shpchp(F) serio_raw(F) pcspkr(F) xfs(F) libcrc32c(F) sd_mod(F) crc_t10dif(F) sr_mod(F) cdrom(F) mptsas(F) radeon(F) i2c_algo_bit(F) scsi_transport_sas(F) drm_kms_helper(F) mptscsih(F) ttm(F) drm(F) mptbase(F) i2c_core(F) usb_storage(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 

Each of which appears to have incurred the:

    [   34.917174] Request for unknown module key 'Magrathea: Glacier signing key: 8b7774b08bc4ee9637073434c10f0823f6fbe523' err -11 

error.

So that seems to be what I thought it was, but it doesn't seem to have been a
problem for most modules.

David
