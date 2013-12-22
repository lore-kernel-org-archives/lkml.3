Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3LVKWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 05:22:12 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42809 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab3LVKWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 05:22:08 -0500
MIME-Version: 1.0
In-Reply-To: <20131217232525.GA12152@earth.universe>
References: <1387150085-23173-1-git-send-email-sre@debian.org>
	<1387150085-23173-7-git-send-email-sre@debian.org>
	<CACRpkdYjjXgE_W8gq1e6z=nGMF=r-m+o2kkvrBFrEMm3o0=RwQ@mail.gmail.com>
	<20131216121524.GA6177@earth.universe>
	<CACRpkdbx=Ye8xo4wMkyntME45xv15DeyqV32aeCAcSaa+vDpfA@mail.gmail.com>
	<20131216183448.GA10614@earth.universe>
	<52B090E0.5040006@gmail.com>
	<20131217232525.GA12152@earth.universe>
Date: Sun, 22 Dec 2013 11:22:06 +0100
Message-ID: <CACRpkdZpAwemVCWubVC6Fe+CNrzPo97uTzyEQt1uD4M2iutnPQ@mail.gmail.com>
Subject: Re: Re: [RFCv4 06/11] misc: Introduce Nokia CMT driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        =?windows-1251?B?yOLg6evuIMTo7Ojy8O7i?= <freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, "pavel@ucw.cz" <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 12:25 AM, Sebastian Reichel <sre@ring0.de> wrote:

> I had a look at both ofono's and freesmartphone.org's implementation
> for the GPIO handling and both implementations are very similar. I
> think it should be possible to move the state machine described in
> [0] into the kernel and provide a simple sysfs/uevent interface.
>
> I was thinking of something like /sys/devices/platform/nokia-cmt/state,
> which accepts "enable", "disable" and "reset" as input and outputs the
> current state.
>
> [0] https://git.kernel.org/cgit/network/ofono/ofono.git/tree/plugins/nokia-gpio.c

Yes this looks like kernel code shoehorned into userspace. As it
deals with suspending/resuming hardware for example, and that is
something the kernel needs to coordinate and do uniformly across
all devices (IMO).

A while back Arun Murthy was working on creating an embedded
modem subsystem but the development stopped. However such a
subsystem is a generic problem of general interest and this would be
one of the candidates for drivers/modem I think. Sadly creating it
may be a lot of work, I don't know exactly.
http://marc.info/?l=linux-kernel&m=135027904405680&w=2

Yours,
Linus Walleij
