Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3FZOi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:38:26 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40016 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544Ab3FZOiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:38:23 -0400
Message-ID: <1372257499.2168.5.camel@dabdike>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Date: Wed, 26 Jun 2013 07:38:19 -0700
In-Reply-To: <20130626135933.GQ22026@console-pimps.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
	 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
	 <51CA2B03.4080106@wwwdotorg.org>
	 <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
	 <20130626135311.GA9078@rocoto.smurfnet.nu>
	 <20130626135933.GQ22026@console-pimps.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 14:59 +0100, Matt Fleming wrote:
> On Wed, 26 Jun, at 03:53:11PM, Leif Lindholm wrote:
> > It's completely feasible, but we'd need to use a different method to do
> > the boot services call with a 1:1 mapping (idmap support is not available
> > until much later in the boot process).
> 
> At least if you no longer relied upon the idmap we could potentially
> have a single efi_enter_virtual_mode() call-site in init/main.c, which
> would be nice.

The fixed virtual address scheme currently being looked at for x86_64 to
make SetVirtualAddressMap() kexec invariant doesn't work on 32 bit
because the address space isn't big enough.  For ARM, given that we've
much more opportunity to work with the vendors, can we just avoid
transitioning to a virtual address map and always just install a
physical mapping before doing efi calls?

James


