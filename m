Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaKZJbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:31:02 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:52094 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbaKZJa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:30:59 -0500
Message-ID: <1416994256.29407.43.camel@x220>
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Greg KH <gregkh@linuxfoundation.org>, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Nov 2014 10:30:56 +0100
In-Reply-To: <54758B9C.3050107@nod.at>
References: <1416958612-7448-1-git-send-email-richard@nod.at>
	 <20141125235108.GB3138@kroah.com> <54751A95.60805@nod.at>
	 <20141126005542.GA14758@kroah.com> <54758B9C.3050107@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2014 09:30:56.0081 (UTC) FILETIME=[AE11A410:01D0095B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 09:13 +0100, Richard Weinberger wrote:
> Am 26.11.2014 um 01:55 schrieb Greg KH:
> > On Wed, Nov 26, 2014 at 01:11:01AM +0100, Richard Weinberger wrote:
> >> Am 26.11.2014 um 00:51 schrieb Greg KH:
> >>> On Wed, Nov 26, 2014 at 12:36:52AM +0100, Richard Weinberger wrote:
> >>>> systemd has a hard dependency on CONFIG_FHANDLE.
> >>>
> >>> It's been this way for a very long time, why is this suddenly an issue?
> >>
> >> Because nobody cared to create patch and just called systemd names? ;-)
> > 
> > systemd documents what is needed in order for it to boot properly quite
> > well, I don't see why this needs to be here.
> 
> Because not every kernel developer knows the contents of the damn systemd readme file.
> Face it, systemd is common userspace and if a defconfig is unable to boot common userspace
> we have a problem.
> 
> Yesterday I was hunting down a regression in libvirt on the shiny new openSUSE 13.2,
> I had to build an older kernel.
> So I did a defconfig because I know that config has all drivers for my KVM setup.
> (No, I my laptop don't has to power to build the bloated .config from suse)

Isn't that considered best practice? Ie, you use a .config provided by
the distribution that you run - of which you know that it will boot your
(hardware/software) setup - as a base to build new kernels. That's what
I do, while my most powerful machine tends to be a laptop bought after
its production already stopped (ie, in clearance sales).

> But systemd went nuts (in terms of doing completely crap things beside of not spawning
> a getty).
> After one hour of painful systemd debugging I found out that I was missing
> CONFIG_FHANDLE.
> 
> I really don't understand why you are so opposed to that change.
> Let's make thing easier for us.
> 
> >>> Do these files even make any sense anymore?  Who uses them?  The distros
> >>> sure do not...
> >>
> >> Maybe I'm oldschool but I expect a defconfig kernel to be able to boot a
> >> recent distro.
> > 
> > You are :)
> > How does the defconfig know your hardware in order to be able to find
> > the root disk properly?  Video device?  USB keyboard?  and so on...

I think I never tried booting a kernel built with a defconfig file. But
are the (hardware/software) setups used by people that build their own
kernel so diverse that it will make a defconfig that covers (a
substantial portion of) that group grow too big? Ie, we end up with
something that looks a lot like what distributions use?

> > I thought we were getting rid of the defconfig files entirely one of
> > these days, didn't some arches already do this?

Looking at
    git ls-files "*defconfig*" | sed -e "s/arch\///; s/\/.*//" | sort -u

it seems all arches have at least one defconfig file. I do think,
however, that arch/arm dropped a substantial number of defconfig files a
few years back.

Anyhow, why should we get rid of the defconfig files entirely? Because
they aren't really useful, since they won't help in building a kernel
that actually boots the targeted systems? Or is it because of the churn
involved in keeping them up to date? (Last time I checked most of them
had accumulated quite a bit of outdated stuff. But the kconfig tools
don't mind, they just skip what isn't used in the Kconfig files
anymore.)

If it's churn, perhaps the defconfig files could be moved into a
separate repository. In that repository they should be regenerated for
every release (and every -rc). That ought to be possible automagically.
The only actual fixes would then be for the problems people notice when
using those defconfig files. I'm not sure how to detect for that
repository which defconfig files can be dropped entirely - because their
targets are not supported anymore. That seems to happen often enough
with obscure, outdated, etc. ARM boards, things like that.

> Please don't.


Paul Bolle

