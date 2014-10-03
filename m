Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaJCML1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:11:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53809 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaJCMLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:11:24 -0400
Date: Fri, 3 Oct 2014 13:11:19 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mark Salter <msalter@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        Daniel Kiper <daniel.kiper@oracle.com>, Russ Anderson <rja@sgi.com>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 7/7] efi_rtc: probe function error out in case no efi
 runtime enabled
Message-ID: <20141003121119.GH14343@console-pimps.org>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <1408007953-15151-1-git-send-email-dyoung@redhat.com>
 <1411403609.25340.55.camel@deneb.redhat.com>
 <20140925211855.GS18635@console-pimps.org>
 <1411681130.25340.101.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411681130.25340.101.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Argh, this was sat in my outbox for over a week)

On Thu, 25 Sep, at 05:38:50PM, Mark Salter wrote:
> On Thu, 2014-09-25 at 22:18 +0100, Matt Fleming wrote:
> > On Mon, 22 Sep, at 12:33:29PM, Mark Salter wrote:
> > > 
> > > Is this still needed after commit da167ad7638759:
> > > 
> > >   rtc: ia64: allow other architectures to use EFI RTC
> > 
> > Umm... we should really look at disabling this for x86, since the EFI
> > time functions don't work on a bunch of machines I've got here.
> > 
> > And it looks like someone enabled this driver and triggered an oops on
> > their 32-bit EFI tablet,
> > 
> >   https://bugzilla.kernel.org/show_bug.cgi?id=84241#c21
> 
> Previously, it depended on IA64. If it's not worth the trouble for
> x86 then I'd say have it depend on !X86 also. Newer EFI-supporting
> architectures are unlikely to have the same legacy issues as x86
> so I don't think it'll end up being an ever growing list.
 
Yeah that's what I was thinking. For x86, it's the age old "Windows
doesn't use it, so it was never validated" issue.

I'll send an update.

-- 
Matt Fleming, Intel Open Source Technology Center
