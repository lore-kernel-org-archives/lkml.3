Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaLHRMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:12:14 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:60140 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaLHRML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:12:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ray Jui <rjui@broadcom.com>, Mark Rutland <mark.rutland@arm.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@linaro.org>, Joe Perches <joe@perches.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, linux-gpio@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 1/5] gpio: Cygnus: define Broadcom Cygnus GPIO binding
Date: Mon, 08 Dec 2014 18:11:08 +0100
Message-ID: <9945772.cPNxB9AH25@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5485D7F8.6090305@broadcom.com>
References: <1418006316-324-2-git-send-email-rjui@broadcom.com> <2594176.SCRFa6Sb3O@wuerfel> <5485D7F8.6090305@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:1q4531nvbm+Zj1Q5qmPc4U1MhBXdSl23spRC+gLDJM37vDNOCjz
 l8qH2XVCApi03AgJPhgXz3W0NFw9bdb7rMP1lXqLpjaVlT/5eq/8PZbedKQYB4fMqLWbEDP
 LUSah3xvnf067+GpAWWc69sQUekksQWdzuwwVoN09WBYTmIfg219iRJ7VxCwNgfkF2aM3np
 4c14tHj0ujfc03hBVcZeQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 08:55:20 Ray Jui wrote:
> 
> On 12/8/2014 3:22 AM, Arnd Bergmann wrote:
> > On Sunday 07 December 2014 18:38:32 Ray Jui wrote:
> >> +Required properties:
> >> +
> >> +- compatible:
> >> +    Currently supported Cygnus GPIO controllers include:
> >> +    "brcm,cygnus-ccm-gpio": ChipcommonG GPIO controller
> >> +    "brcm,cygnus-asiu-gpio": ASIU GPIO controller
> >> +    "brcm,cygnus-crmu-gpio": CRMU GPIO controller
> >
> > How different are these? If they are almost the same, would it
> > be better to use the same compatible string for all of them and
> > describe the differences in extra properties?
> >
> > If they are rather different, maybe you should have a separate
> > binding and driver for each?
> >
> > 	Arnd
> >
> They are quite similar with the following minor differences:
> 1) ChipcommonG GPIO controller uses a separate register block 
> (0x0301d164) to control drive stregnth
> 2) Cannot control drive strength for the CMRU GPIO

This can be deducted from having one or two register blocks I
assume.

> 3) CRMU GPIO controller's interrupt is not connected to GIC of A9. 
> Currently that's taken care of by using a "no-interrupt" device tree 
> property

No need for this property even, just see if there is an "interrupts"
property or not.
 
> I can change to use the common compatible string "brcm,cygnus-gpio". 
> With an introduction of property "no-drv-stregnth" which should be set 
> for CRMU GPIO controller. 

Ok.

> For ChipcommonG GPIO, it will have a second 
> register block defined, so we'll know to use that second register block 
> for drive strength configuration. For the rest, we assume normal drive 
> strength configuration (i.e., ASIU in our case).

Maybe see if something older than cygnus was already using a compatible
gpio controller and then use the name of that.

> Looking at this again, it looks like the "no-interrupt" property is 
> really redundant. For GPIO controller without interrupt connected to A9, 
> we can simply leave its interrupt properties not defined. I'll get rid 
> of it along with the above changes.

Right.

	Arnd
