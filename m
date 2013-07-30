Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3G3Ncu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:32:50 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47423 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332Ab3G3Ncs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:32:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
Date: Tue, 30 Jul 2013 15:42:58 +0200
Message-ID: <3453253.oZLO1ChPbL@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51F755E3.8040706@gmail.com>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com> <51F7546C.9030901@gmail.com> <51F755E3.8040706@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 30, 2013 01:57:55 PM Aaron Lu wrote:
> On 07/30/2013 01:51 PM, Aaron Lu wrote:
> > On 07/30/2013 11:44 AM, Felipe Contreras wrote:
> >> On Mon, Jul 29, 2013 at 10:11 PM, Aaron Lu <aaron.lwe@gmail.com> wrote:
> >>> On 07/30/2013 03:20 AM, Felipe Contreras wrote:
> >>>> Since v3.7 the acpi backlight driver doesn't work at all on this machine
> >>>> because presumably the ACPI code contains stub code when Windows 8 OSI is
> >>>> reported.
> >>>>
> >>>> The commit ea45ea7 (in v3.11-rc2) tried to fix this problem by using the intel
> >>>> backlight driver, however, on this machine it turns the backlight completely
> >>>> off when it reaches level 0%, after which the user might have a lot trouble
> >>>> trying to bring it back.
> >>>
> >>> What do you mean by a lot of trouble? If you press hotkey to increase
> >>> backlight brightness level, does it work?
> >>
> >> I guess so, *if* there is indeed a user-space power manager handling
> >> that, *and* the keyboard has such keys, *or* the user has set custom
> >> hotkeys.
> > 
> > Right, for a GUI environment this may not be a big problem(user uses Fn
> > key to decrease brightness level and then hit the black screen, it's
> > natural he will use Fn key to increase brightness level).
> > 
> >>
> >>> If so, the screen should not
> >>> be black any more, it's not that user has to blindly enter some command
> >>> to get out of the black screen.
> >>>
> >>> And I'm not sure if this is a bug of intel_backlight(setting a low level
> >>> makes the screen almost off), I see different models with different
> >>> vendors having this behavior.
> >>
> >> I mean, the screen is completely off, I cannot see absolutely
> >> anything. I don't see this behavior with the ACPI backlight driver,
> >> nor do I see that in Windows 7.
> >>
> >>> If this is deemed a bug, then I'm afraid
> >>> intel_backlight interface is useless for a lot of systems...perhaps we
> >>> can only say, intel_backlight's interpretation of low levels are
> >>> different with ACPI video's, and that's probably why its type is named
> >>> as raw :-)
> >>
> >> Well, a bug is defined as unexpected behavior -- as a user, if I'm
> >> changing the brightness of the screen, I certainly don't expect the
> >> screen to turn off, and I think that's the expectation from most
> >> people. It's the first time I see something like that.
> > 
> > I agree this is kind of un-expected. At the same time, this seems to be
> > the normal behavior for intel_backlight. I don't know what the correct
> > thing to do here if this is something we want to avoid - modify intel
> > backlight handling code not to set too low value or change the user
> > space tool not to set a too low value if they are interacting with a
> > raw type interface. Neither of them sounds cool... Or, users may get
> > used to it, I for example, don't find this to be very annoying, but
> > maybe I'm already used to it.
> 
> BTW, for the complete screen off problem, I don't see there is anything
> wrong with it from code's point of view. It's not that there is an error
> in code or this is a broken hardware that caused the screen off when
> setting a very low or 0 brightness level, it is simply the expected
> behavior of what this interface can provide. It can really set the
> brightness level to minimum(zero) or maximum. Don't get me wrong, I
> didn't mean this is a good user experience, I don't know that. I just
> don't think this is a program bug, and I don't know if this should be
> fixed or not - obviously this interface did what it is asked to do,
> correctly.

Precisely, user space asks for 0 and the kernel delivers.

And there are reasons why 0 should be "screen off", like power management
(when you have a policy to dim the screen completely after a period of
inactivity, for example).

So in my opinion, if that's a problem for anyone, it has to be addressed in
user space and if there are any vendors who try to address *that* in their ACPI
tables, that's one more reason to avoid using ACPI for backlight control.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
