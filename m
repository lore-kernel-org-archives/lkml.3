Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbbAMLlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:41:32 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:36718 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751253AbbAMLl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:41:29 -0500
Date: Tue, 13 Jan 2015 11:41:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>, Joe Perches <joe@perches.com>,
        Scott Branden <sbranden@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] gpio: Cygnus: define Broadcom Cygnus GPIO binding
Message-ID: <20150113114101.GO12302@n2100.arm.linux.org.uk>
References: <1418342706-14755-2-git-send-email-rjui@broadcom.com>
 <1918116.UxUgDPTmcq@wuerfel>
 <CAAVeFuL2MKRA7YLm_wsyftNy-sxgEYPrmqBm8XTRZQb66YF-qw@mail.gmail.com>
 <1628217.66frkAqHMc@wuerfel>
 <CAAVeFuJhiten-eVLCa2sMG-nsRwjPMiZap8UJM1kNCuRyK-b1w@mail.gmail.com>
 <20141217104428.GV11285@n2100.arm.linux.org.uk>
 <CACRpkdZbGjNecrggrFr_18zjobXMBpkrSjBMAUfyfs2ZCebB0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZbGjNecrggrFr_18zjobXMBpkrSjBMAUfyfs2ZCebB0w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 09:06:15AM +0100, Linus Walleij wrote:
> On Wed, Dec 17, 2014 at 11:44 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Wed, Dec 17, 2014 at 11:45:01AM +0900, Alexandre Courbot wrote:
> >> Actually we are not that far from being able to do completely without
> >> any GPIO number, and maybe that's what we should aim for. I think the
> >> only remaining offender is the sysfs interface.
> >
> > And that is a user API, and there's lots of users of it (eg, on Raspberry
> > Pi platforms.)  So changing it isn't going to be easy - I'd say that it's
> > impractical.
> >
> > What you're suggesting would be like re-numbering Linux syscalls.
> 
> The problem is that right now if we set the .base of a gpio_chip
> to -1 for dynamic allocation of GPIO numbers and we have more
> than one GPIO chip in the system, the numbers basically depend
> on probe order, and may theoretically even differ between two boots.
> 
> So in these cases preserving the ABI means preserving the
> unpredictability of these assigned numbers or something.
> 
> For the old usecases with a single GPIO controller and a fixed
> base offset of e.g. 0 (which I suspect was implicit in the initial
> design of the subsystem) things work fine as always, it's these new
> dynamic use cases that destabilize the ABI.

Since GPIOs are exported through sysfs into userland by GPIO number,
and we know that there are users of it (see
https://github.com/pilight/wiringX) which hard encode GPIO numbers,
so this is *really* something that we as kernel developers can't
change without breaking such users.

So, what I'm saying is be very careful about moving to a fully
dynamic space: you could end up breaking userspace if you do.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
