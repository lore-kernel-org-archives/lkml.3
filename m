Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443AbaDIVws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:52:48 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:54525 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933908AbaDIVwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:52:46 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:800:67f1:d4e6:c46d]
In-Reply-To: <1397072736-10793-2-git-send-email-matthias.bgg@gmail.com>
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com>
	<1397072736-10793-2-git-send-email-matthias.bgg@gmail.com>
Date: Wed, 9 Apr 2014 14:52:45 -0700
Message-ID: <CAOesGMg2zvPPeyqTvztiNKVJzWP5PsNs2pkXKMaS+CfXHgO0rQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] clocksource: Add support for the Mediatek SoCs
From: Olof Johansson <olof@lixom.net>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>, florian.vaussard@epfl.ch,
        Jonathan Cameron <jic23@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        silvio.fricke@gmail.com, heiko.stuebner@bq.com,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 9, 2014 at 12:45 PM, Matthias Brugger
<matthias.bgg@gmail.com> wrote:
> This patch adds a clock source and clock event for the timer found
> on the Mediatek SoCs.
>
> The Mediatek General Porpose Timer block provides five 32 bit timers and
> one 64 bit timer.
>
> Two 32 bit timers are used:
> TIMER1: clock events supporting periodic and oneshot events
> TIMER2: clock source configured as a free running counter
>
> The General Porpose Timer block can be run with two clocks. A 13 MHz system
> clock and the RTC clock running at 32 KHz. This implementation uses the system
> clock.

Hm, are you planning on using these on the Cortex-A7-based and newer
SoCs? On those, the arm generic timers should be available, and you
might be better off just using those there.

Of course, you'll still need these for the A9-based platforms, so the
driver might very well be needed anyway. Some of the earlier patches
seem to be for A7-based systems so I'm not sure what you're primarily
working on here. :)


-Olof
