Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbaGAQwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:52:21 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59029 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521AbaGAQwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:52:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, Alexandre Courbot <gnurou@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Chris Ball <chris@printf.net>,
        Chen-Yu Tsai <wens@csie.org>, Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC 1/2] pwrseq: Add subsystem to handle complex power sequences
Date: Tue, 01 Jul 2014 18:51:24 +0200
Message-ID: <4396181.E2W0ve8f6g@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPDyKFqi2NH1r=Q13iOu2ruuvaj1xJeoERiy2WJBVbQ2b1tc_A@mail.gmail.com>
References: <1403183091-27876-1-git-send-email-ulf.hansson@linaro.org> <53A3ED65.80605@redhat.com> <CAPDyKFqi2NH1r=Q13iOu2ruuvaj1xJeoERiy2WJBVbQ2b1tc_A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:juIrgT7H87Y50m6m7RtZqUN4zbKC9q3BBBqOxI5yEPJ
 QE9198n52ySgt31eHNM5yLz1Ieh1gHyRqJXILW1WYk6WVB85XQ
 yWiSO9FQSC7VP+7UYYEcgbcQJhyK787dSSTIGKq2RrEwThxFVL
 vkS9GjOIQG2YZcq4+d5DYA8ONRP/b5ilor+1pXAXNtdJOzHS1E
 p01aoj27Y51paucT6+a0KyhbPzC3B+q2HT/SOI5ZfmexRrYpmF
 EPj8qtn/8bc8ix21AsZiWpu8MxsLpdQI0x8XuxYOntxermGs5m
 01b+eGjxHSzCRRaOxw4KYH7wnJ7XOCM6+Galv1XPgYDHafNdFu
 qbzAFhMe4eGOafxXey9k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2014 18:42:51 Ulf Hansson wrote:
> On 20 June 2014 10:14, Hans de Goede <hdegoede@redhat.com> wrote:
> > On 06/20/2014 10:02 AM, Olof Johansson wrote:
> >> On Fri, Jun 20, 2014 at 12:27 AM, Hans de Goede <hdegoede@redhat.com> wrote:
> >> I disagree.
> >>
> >> The clock is the input to the module, and it is what needs to be
> >> enabled for the module to work. It's not the input to some
> >> power-sequence component on the module, or next to the module on the
> >> bus.
> >
> > Right, it is an input to the sdio-module, not to the mmc-host, so its an
> > input to a different piece of hardware (at different ends of the mmc bus),
> > but since the mmc-bus normally is fully discoverable we've no node for the
> > other end of the bus.
> >
> > So from the mmc-host pov, which is the one which needs to bind the pwrseq
> > driver, as that needs to be done before it can probe its bus, this is
> > a different piece of hardware, hence a subnode to the host makes perfect
> > sense.  This is in no way part of the host, so certainly it does not belong
> > inside the hosts subnode.
> 
> I fully agree with you Hans here.
> 
> If we were to put this information in the host's DT node, that would
> be a wrong description of the hardware. Currently, I can't think of
> anything better than a subnode, but I am open to suggestions.

The problem that I see with your approach is that you use a subnode
to describe an abstract concept, which isn't really a better description
of the hardware than putting the contents in the parent node itself.

It would be more sensible if the subnode was defined (in this case)
as describing the attached device (sdio card or similar), and restructure
the code around that concept.

	Arnd
