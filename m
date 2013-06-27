Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3F0GXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:23:47 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:64236 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3F0GXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:23:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130627013219.GA346@srcf.ucam.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <51CA2B03.4080106@wwwdotorg.org> <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
 <20130626135311.GA9078@rocoto.smurfnet.nu> <20130626135933.GQ22026@console-pimps.org>
 <1372257499.2168.5.camel@dabdike> <20130627013219.GA346@srcf.ucam.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 27 Jun 2013 07:23:23 +0100
X-Google-Sender-Auth: C9VZsuwG96Q9zCvpq4GcdL5jwLc
Message-ID: <CACxGe6uFkbuJ3BxM=A0Lu=jZQ79Ba8SmNsdBdTOO13szTfTZ=Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Matt Fleming <matt@console-pimps.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 2:32 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Jun 26, 2013 at 07:38:19AM -0700, James Bottomley wrote:
>> The fixed virtual address scheme currently being looked at for x86_64 to
>> make SetVirtualAddressMap() kexec invariant doesn't work on 32 bit
>> because the address space isn't big enough.  For ARM, given that we've
>> much more opportunity to work with the vendors, can we just avoid
>> transitioning to a virtual address map and always just install a
>> physical mapping before doing efi calls?
>
> We can probably get away with that now, but it does risk us ending up
> with some firmware that expects to run in physical mode (boards designed
> for Linux) and some firmware that expects to run in virtual mode (boards
> designed for Windows). The degree of lockdown in the Windows ecosystem
> at present means it's not a real problem at the moment, but if that ever
> changes we're going to risk incompatibility.

What is the problem trying to be avoided by not using the virtual map?
Is it passing the virtual mapping data from one kernel to the next
when kexecing? Or something else?

g.
