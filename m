Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaDKJWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:22:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:64665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbaDKJWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:22:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Jonathan Cameron <jic23@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Silvio F <silvio.fricke@gmail.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko.stuebner@bq.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/4] clocksource: Add support for the Mediatek SoCs
Date: Fri, 11 Apr 2014 11:21:59 +0200
Message-ID: <129772722.mXH1xx9vCv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CABuKBeKr77qJwusoTgjR2yOspWbi6Exvt5i8WPc5tjd7fez-YA@mail.gmail.com>
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com> <CAOesGMg2zvPPeyqTvztiNKVJzWP5PsNs2pkXKMaS+CfXHgO0rQ@mail.gmail.com> <CABuKBeKr77qJwusoTgjR2yOspWbi6Exvt5i8WPc5tjd7fez-YA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7M3Dkc7fXOTCsWfNGItxKWfNlolrXf+NNe8Zedz5cM1
 eKH6W2JPjMA0HLdNBsbvS3iH2ovgX0bVmh2AStrK8azJiwX+7a
 sVmYIbhmokH9DT27ltmeB6eMLLCcI+T8MKDs2dyquUr+vSnKrw
 rQbw0k+AkWCY6UAs04/4whlIjwmPHNTCly/jo8oPugHeDk6VCT
 U9wTUZY+9zJsGLAttLCgMrJC0h+DCPQjnofFhSfXGMQojGv1fv
 bl667nVbrebfK7BY9BHcoKnO9DSVf2eoqNQcd2i7tHWm4xHaW1
 PBrNeXXPXlhJjHso1YutBOwLclat7/SSKXF8hHaQMGKpi+wj6I
 mRe+6efJzxOW4TvGEl1Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 April 2014 11:07:35 Matthias Brugger wrote:
> >
> > Of course, you'll still need these for the A9-based platforms, so the
> > driver might very well be needed anyway. Some of the earlier patches
> > seem to be for A7-based systems so I'm not sure what you're primarily
> > working on here. 
> 
> I'm working on a Cortex-A7 based platform. But ARM_ARCH_TIMER seems to
> get no clocking.
> Initializing the timer fails with:
> Architected timer frequency not available
> 
> That's why I use the SoC timer.

Are you sure you're not just missing a "clock-frequency" property
in your DT node for the timer?

	Arnd
