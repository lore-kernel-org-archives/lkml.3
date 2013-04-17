Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966370Ab3DQNnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:43:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966099Ab3DQNnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:43:06 -0400
Date: Wed, 17 Apr 2013 15:43:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Victor M." <vvm@tut.by>
Cc: Jan Beulich <JBeulich@suse.com>, olaf@aepfle.de, bp@alien8.de,
        apw@canonical.com, x86@kernel.org, tglx@linutronix.de,
        devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: KVM "Hyper-V emulation" -- this can be related "Linux on
 Hyper-V" ? Or "KVM emulates Hyper-V" as "Hyper-V emulates Hyper-V" ? Re:
 [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Message-ID: <20130417124352.GC6801@redhat.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
 <20130417070616.GA4487@redhat.com>
 <39D7C3658A5B4979A3F025E1D944E743@local.st.by>
 <20130417101617.GF3881@redhat.com>
 <516EADD502000078000CE112@nat28.tlf.novell.com>
 <CAP2xkNqGgbYz1gdS85xjA8gwROGY89fAsiaRiGSE90xnzjJ4Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP2xkNqGgbYz1gdS85xjA8gwROGY89fAsiaRiGSE90xnzjJ4Xw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 04:03:08PM +0300, Victor M. wrote:
> Hi!
> 
> 2013/4/17 Jan Beulich
> 
>     >>> On 17.04.13 at 12:16, "Michael S. Tsirkin"  wrote:
>     > If the hypervisor says it's Hyper-V, that's because it wants
>     > guests to use Hyper-V. I don't see why is guest second-guessing
>     > this a good idea.
> 
>     There are two reasons here: For one, when the hypervisor is not
>     Hyper-V, but is providing some Hyper-V emulation, that's intended
>     for Windows guests to use, not e.g. Linux ones, especially when
>     such guests could use the native hypervisor interface with much
>     greater benefit.
> 
>     And second, there reportedly are features of (newer?) Hyper-V
>     that some emulation may not provide, but that are also not easily
>     detectable.
>    
> 
> 
> 
> Yes
>  
> +
>  
> 
> > On Wed, Apr 17, 2013 at 12:10:01PM +0300, Victor Miasnikov wrote:
> 
> 
> 
> >>
> >> Question is very simple:  Hyper-V users/sysadmins need wait patch a-la this:
> >> Or 
> "KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V
> emulates Hyper-V" as "Hyper-V emulates
> >> Hyper-V" ?
> >>
> >
> > No.  You are using Hyper-V, not the
> KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V
> > emulation of it.
> > No patches dealing with this emulation should have any effect on you.
> 
> 
>  This is _positive_ variant of possible future,
> but on _practic_ very often we need prevent _negative_ variant of possible
> future

I don't really know what this means.

> 
> >> ==
> >> + /*
> >> +  *
> KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V
> emulates Hyper-V to support
> >> enlightened Windows.
> >> +  * Check to see first if we are on a
> KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V
> >> Hypervisor.
> >> +  */
> >> +
> >> + if
> (KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V_cpuid_base
> ())
> >> +  return false;
> 
> >
> > If the hypervisor says it's Hyper-V, that's because it wants guests to use
> Hyper-V.
> >
> 
> 
>  Even if guest ( i.e. Virtual Computer) contain Linux OS ?

Why not?  If you don't want the hypervisor to emulate hyper-v, just
don't tell it to emulate hyper-v.


> 
> >> ==
> >> KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V
> emulates Hyper-V to host enlightened
> >> Windows.
> >>
> >> . . .
> >>
> >> [ hpa: the problem here is that
> >> KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V
> doesn't emulate Hyper-V well enough,  .
> >>  . ]
> >
> > What's emulated not well enough?
> >
> 
>  In case of XEN variant non-full-emulation_of_Hyper-V , IMHO :
> 
> {{
> ----- Original Message -----
> From: "Victor Miasnikov"
> To: "Michael S. Tsirkin"
> Sent: Wednesday, April 17, 2013 12:41 PM
> Subject: IMHO, XEN emulation of Hyper-V not contain needed clocksource for
> Lunux guest Re: [PATCH 2/3] X86: Add a check
> to catch Xen emulation of Hyper-V
> 
> Hi!
> 
> > It seems that one might want to use hyper-v emulation e.g. to test
> > hyper-v code without using windows, so the functionality
> > that this patch disables is not completely useless,
> > so there should be a good reason for disabling it.
> 
>  As I undestand, XEN emulation of Hyper-V not contain  needed clocksource for
> Lunux guest ( virtual computers)
> 
> I.e. Linux VM "think" what is running on Hyper-V host call
> clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100)
> and a-la BSOD or vica verse . . .
> 
> 
> > I went over the original discussion in
> > https://patchwork.kernel.org/patch/2064331/
> > and that's still not clear to me. Is there a configuration
> > that is broken without this patch but starts working with
> > this patch?
> 
> 
>  IMHO, this related to:
> 
> - clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> + if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
> +  clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> 
> 
>  See
> 
> https://lkml.org/lkml/2013/2/12/623
> ==
>             Date Tue, 12 Feb 2013 16:56:07 -0800
>             From tip-bot for Olaf Hering
>             Subject [tip:x86/hyperv] x86: Hyper-V: register clocksource only if
> its advertised
> 
>  . . .
> 
> ==
> 
> 
> 
> Best regards, Victor Miasnikov
> }}
> 
> 
> 
> 
> 
> Best regards, Victor Miasnikov
> Blog:  http://vvm.blog.tut.by/

Looks like a counter-example to me.

Apparently a Linux guest bug was found and fixed exactly because we
trust the hypervisor.  If it wasn't, and if in the future hyper-v hosts
clear this feature bit, Linux will be broken.

-- 
MST
