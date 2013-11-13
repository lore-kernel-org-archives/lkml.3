Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab3KMX5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:57:19 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:33172 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMX5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:57:13 -0500
Date: Wed, 13 Nov 2013 16:57:08 -0700
From: jerry.hoemann@hp.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        matt.fleming@intel.com, yinghai@kernel.org, penberg@kernel.org,
        akpm@linux-foundation.org, linux-doc@vger.kernel.org,
        linux-efi@vger.kernel.org, vgoyal@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Early use of boot service memory
Message-ID: <20131113235708.GC25344@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
 <20131113224503.GB25344@anatevka.fc.hp.com>
 <52840206.5020006@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52840206.5020006@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 02:49:42PM -0800, H. Peter Anvin wrote:
> On 11/13/2013 02:45 PM, jerry.hoemann@hp.com wrote:
> > 
> > The changes in 3.9 to allow crash kernel to be allocated high helps. 
> > But as you say, the default is still to allocate crash kernel low and
> > still susceptible to this problem.  So, a kdump expert can work around it.
> > But, not everyone is a kdump expert.
> > 
> > So, we can work to change the default, or encourage the distros
> > to always allocate high.  Or, we change the call to efi_reserve_boot_services
> > not apply to all platforms.
> > 
> > The problems for pre 3.9 based distros is worse as they don't have
> > ability to allocate crash kernel high.
> > 
> 
> But they won't have your new option, either,


I am working with distro partners on this issue.
I hope we can find a solution that all can live with.


> 				and that is still horribly
> manual and system-dependent.


I think i can go to a date based black list, that removes the manual
step.  System running firmware before certain date assumes we need
to do the work around.  If firmware is newer than that date, we don't
use the workaround.  Blacklist overrides and allows current behavior
for new firmware that is subsequently found to be broken and for
which we can't convenience the manufacturer to fix.


> 
> In other words, allocating the crashkernel high has ALL the advantages,
> plus a few more, and NONE of the disadvantages.
> 
> 	-hpa

Not exactly.

Firmware shouldn't be accessing these regions after exit boot services.
i like to find/fix firmware bugs.  efi_reserve_boot_services hides this
particular type of error.  Good or bad,  much of platform/firmware
validation is based upon booting/running OSes.

Also, there are kernel/tools rev locks in allocating crash kernel high.
Bigger, more coordination, etc...,


Don't get me wrong.  I think not restricting crash kernel allocation
to low memory is big improvement.  

I will still point out that as currently used, efi_reserve_boot_services
is wrong.  A work around for firmware bugs on one platform shouldn't be
breaking platforms that don't have that bug.  Its just much less likely
to cause problems with higher crash kernel allocation.




-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

