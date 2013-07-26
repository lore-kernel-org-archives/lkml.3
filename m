Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab3GZUyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:54:23 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:48612 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab3GZUyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:54:17 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Vincent Palatin <vpalatin@chromium.org>,
        Grant Likely <grant.likely@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olofj@chromium.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH] regulator: read low power states configuration from device tree
Date: Fri, 26 Jul 2013 22:54:10 +0200
Message-ID: <2074197.ld4vucf8Ke@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130725200343.GV9858@sirena.org.uk>
References: <1374781320-10793-1-git-send-email-vpalatin@chromium.org> <20130725200343.GV9858@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 of July 2013 21:03:43 Mark Brown wrote:
> On Thu, Jul 25, 2013 at 12:42:00PM -0700, Vincent Palatin wrote:
> > +- regulator-suspend-disk-microvolt: voltage applied when entering S2D
> > +- regulator-suspend-disk-disabled: turn off when entering S2D
> > +- regulator-suspend-mem-microvolt: voltage applied when entering S2M
> > +- regulator-suspend-mem-disabled: turn off when entering S2M
> > +- regulator-suspend-standby-microvolt: voltage applied when entering
> > standby +- regulator-suspend-standby-disabled: turn off when entering
> > standby
> The reason this isn't in device tree at the minute is that suspend to
> disk and suspend to RAM are somewhat Linux specific concepts and the
> whole thing gets more and more dynamic as time moves forwards with the
> suspend state for practical systems depending on the instantaneous
> device state prior to entering suspend and the bits that are fixed often
> involving sequencing elements and so on which get fixed in hardware
> and/or bootloader.  Do you have practical systems where this is needed?

We do have such boards at Samsung. Actually I made a similar patch for our 
internal tree.

> It's also not clear to me hat the -disabled properties make sense; if we
> have properties for the state when enabled I'd expect them to allow
> things to be marked as enabled or disabled (with don't touch as the
> default).

+1

Best regards,
Tomasz

