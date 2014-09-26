Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaIZRwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:52:34 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51143 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbaIZRwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140926152835.GK10233@codeaurora.org>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
	<1411662520-22795-3-git-send-email-geert+renesas@glider.be>
	<CAPDyKFrAv9oyBzX764+CWkOxfN1kN_MddB3ks1q69+TnmnHXuQ@mail.gmail.com>
	<20140926152835.GK10233@codeaurora.org>
Date: Fri, 26 Sep 2014 19:52:29 +0200
X-Google-Sender-Auth: t7HMV5J8e0vqBKgR4fJOFhxFoD8
Message-ID: <CAMuHMdU+4MX-XYe9rHmyPN3=-VQRg+CrnxWEaU2M_Jg+1Psw8A@mail.gmail.com>
Subject: Re: [PATCH v3 02/13] PM / Domains: Add DT bindings for power-on/off latencies
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Sep 26, 2014 at 5:28 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 25 September 2014 18:28, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
>> > +Optional properties:
>> > + - power-on-latency: Power-on latency of the PM domain, in ns,
>> > + - power-off-latency: Power-off latency of the PM domain, in ns.
>> > +
>> >  Example:
>> >
>> >         power: power-controller@12340000 {
>> >                 compatible = "foo,power-controller";
>> >                 reg = <0x12340000 0x1000>;
>> >                 #power-domain-cells = <1>;
>> > +               power-on-latency = <250000>;
>> > +               power-off-latency = <250000>;
>
> This assumes every power domain within a power controller has the
> same latencies? That isn't always true. This should be an array
> of values corresponding to the number of power domains if
> #power-domain-cells is 1, or just one value if the cell count is
> 0.

Thanks, you're right. Will update.

However, I'd still like to allow just one value in the #power-domain-cells = <1>
case if the latencies are the same. Is that OK for you?

Thanks again.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
