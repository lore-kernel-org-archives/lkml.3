Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3JRK7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 06:59:30 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:44145 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3JRK72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 06:59:28 -0400
Date: Fri, 18 Oct 2013 12:59:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, John Stultz <john.stultz@linaro.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: honor ACPI FADT flag indicating absence of a CMOS
 RTC
Message-ID: <20131018105923.GB17696@gmail.com>
References: <525E969E02000078000FB710@nat28.tlf.novell.com>
 <20131018062908.GD14264@gmail.com>
 <5261015702000078000FBFA1@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5261015702000078000FBFA1@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 18.10.13 at 08:29, Ingo Molnar <mingo@kernel.org> wrote:
> > * Jan Beulich <JBeulich@suse.com> wrote:
> > 
> >> We shouldn't be creating a corresponding platform device in that case.
> > 
> > There's a sad lack of context in the changelog, how was it found, does 
> > this address any problem/bug observed in practice, etc?
> 
> This was a result from code review in Xen hypervisor code in the context 
> of ACPI 5 work there, which lead me to check whether Linux would honor 
> that flag. No known issue in practice so far. Once the below got 
> clarified, I can certainly extend the description in an eventual 
> resubmission (albeit I would have though that fixing the not honoring of 
> a firmware flag should speak for itself).

I thought we've been through this before, firmware related changes never 
'speak for themselves'!

The quality and effect of firmware flags varies wildly (sometimes they are 
good and avoid problems, sometimes they are crap and cause problems) and 
it's important to know the full context.

So in this area there's no such thing as being overly verbose in a 
changelog.

> >> +#ifdef CONFIG_ACPI
> >> +	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC)
> >> +		return -ENODEV;
> >> +#endif
> > 
> > It might also be prudent to emit a KERN_INFO line telling that we don't 
> > create the device - so that people who suddenly see unexpected breakage or 
> > change in behavior have a chance to see what we've done?
> 
> There are so many other -ENODEV return paths here which don't
> emit messages that this seemed inappropriate, the more that a
> message _is_ being issued if the platform RTC device does get
> registered (and hence one could judge by the message
> disappearing between before and after the patch got applied).

I'm trying to be conservative and protect users against potential bad side 
effects of such a change. It's routine. We can mark it as temporary and 
zap it a few kernel releases later.

Thanks,

	Ingo
