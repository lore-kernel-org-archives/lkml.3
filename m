Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3KUXbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:31:15 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:26478 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3KUXbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:31:11 -0500
Date: Thu, 21 Nov 2013 16:31:04 -0700
From: jerry.hoemann@hp.com
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org,
        akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Message-ID: <20131121233104.GF1106@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <20131121230744.GA31592@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121230744.GA31592@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:07:44PM +0000, Matthew Garrett wrote:
> On Thu, Nov 21, 2013 at 02:01:24PM -0700, Jerry Hoemann wrote:
> > 
> > Some platform have firmware that violates the UEFI spec and access boot
> > service code or data segments after the system has called ExitBootServices().
> > The call to efi_reserve_boot_services in setup_arch is a workaround to
> > avoid using boot service memory until after the kernel has done
> > SetVirtualAddressMap.  However, this reservation fragments memory
> > which can cause large allocations early in boot (e.g. crash kernel)
> > to fail.
> 
> This is a problem we have to solve, but I don't think this is the right 
> way to solve it. Why do we not just reattempt to perform the allocation 
> immediately after we've freed the boot services regions?


Hi Matthew,

I tried this back on 3.11 kernel and reserve_crashkernel after free of
boot services failed.  I will admit to not digging in too deeply as to
why it failed.

My earlier email:

https://lkml.org/lkml/2013/9/18/457


thanks


> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

