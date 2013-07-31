Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab3GaLiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:38:18 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:56447 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3GaLiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:38:16 -0400
Message-ID: <51F8F70F.70208@elopez.com.ar>
Date: Wed, 31 Jul 2013 08:37:51 -0300
From: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "kevin.z.m.zh" <kevin.z.m.zh@gmail.com>
CC: "maxime.ripard" <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        =?UTF-8?B?5a2Z5b2m6YKm?= <sunny@allwinnertech.com>,
        =?UTF-8?B?5ZC05Lmm6ICV?= <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ARM: sun6i: Enable clock support in the DTSI
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com> <1375195462-19566-5-git-send-email-maxime.ripard@free-electrons.com> <51F86A2E.10505@elopez.com.ar>,  <20130731073724.GA24439@lukather> <2013073116110750016327@gmail.com>
In-Reply-To: <2013073116110750016327@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El 31/07/13 05:11, kevin.z.m escribió:
> Hi, Maxime,
>  
>> The problem is a bit more complex than that.
>  
>> On the A31, the losc clock is actually a mux between an external
>> oscillator running at 32kHz, and the internal oscillator running at
>> 667MHz, that would be scaled down.
>  
>> Support for this mux is not quite there yet, since I've not seen any
>> documentation for it, but this would allow to just rearrange losc
>> parents and compatible when we will had such support.
>  
> I think there is some misunderstanding. All allwinner's platforms have
> 2 losc clock source. One is the external 32KHz oscillator, and the other
> is internal 32kHz R/C circuit. The internal 32k R/C circuit can't provide
> a very exact clock on 32KHz. The mux is just for select external osc or
> internal
> 32KHz R/C. If there is no external 32kHz oscillator, we can replace it with
> internal 32kHz R/C for some low speed but not exact clock requirement.

Thanks for the clarification :)

(snip)

>> > + ahb1_mux: ahb1_mux@01c20054 {
>> > + #clock-cells = <0>;
>> > + compatible = "allwinner,sun6i-ahb1-mux-clk";
>> > + reg = <0x01c20054 0x4>;
>> > + clocks = <&osc32k>, <&osc24M>, <&axi>, <&pll6>;
>> > + };
>> > +
>> > + ahb1: ahb1@01c20054 {
>> > + #clock-cells = <0>;
>> > + compatible = "allwinner,sun4i-ahb-clk";
>> > + reg = <0x01c20054 0x4>;
>> > + clocks = <&ahb1_mux>;
>> > + };
>> 
>> Depending on when this lands, I believe these two above could be merged
>> into one with the refactoring introduced on my patchset.
>  
> Since your patchset is still in RFC and we had no comments from Mike so
> far, while this one looks pretty similar to the one we had before, I
> guess the safest thing to do would be to rebase your patches on top of
> this ones.

Ok, I'll do that.

Cheers,

Emilio
