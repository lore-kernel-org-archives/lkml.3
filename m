Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaCNVQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:16:42 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:49623 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaCNVQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:16:40 -0400
MIME-Version: 1.0
In-Reply-To: <7h38ikij1d.fsf@paris.lan>
References: <1394742919-32163-1-git-send-email-joelf@ti.com>
	<1394742919-32163-4-git-send-email-joelf@ti.com>
	<CAL_JsqJVPVybd90WUv_nCqUJMUgR+Ep3yxrX2+psNYqic-WQ1Q@mail.gmail.com>
	<532240F0.1030403@ti.com>
	<7h38ikij1d.fsf@paris.lan>
Date: Fri, 14 Mar 2014 16:16:39 -0500
X-Google-Sender-Auth: 5JwG3RoEzJGvV4RoFcOoS72XgkY
Message-ID: <CAL_JsqJpyO_N-YSvfq+YupJw8Eo_TM1AoHkRqaEHcXCry7t-Dg@mail.gmail.com>
Subject: Re: [RFC 3/5] ARM: OMAP2+: timer: Add clocksource initialization and
 powerup support
From: Rob Herring <robh@kernel.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Joel Fernandes <joelf@ti.com>, Tony Lindgren <tony@atomide.com>,
        Tero Kristo <t-kristo@ti.com>, Nishanth Menon <nm@ti.com>,
        Suman Anna <s-anna@ti.com>, Felipe Balbi <balbi@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 4:09 PM, Kevin Hilman <khilman@linaro.org> wrote:
> Joel Fernandes <joelf@ti.com> writes:
>
>> On 03/13/2014 04:52 PM, Rob Herring wrote:
>>> On Thu, Mar 13, 2014 at 3:35 PM, Joel Fernandes <joelf@ti.com> wrote:
>>>> Introduce a generic omap timer initialization function that can
>>>> be used by all SoCs for which support is available in the clocksource
>>>> driver introduced in the series.
>>>>
>>>> The function will also be responsible for calling clock initialization
>>>> required for everything else to work.
>>>>
>>>> Signed-off-by: Joel Fernandes <joelf@ti.com>

[snip]

>>>> +void omap_generic_timer_init(void)
>>>> +{
>>>> +       if (!of_have_populated_dt())
>>>> +               BUG_ON("Generic timer init should only be used for DT boot\n");
>>>
>>> I thought omap2 is always DT boot now.
>>
>> That's right, sorry- I'll get rid of the check.
>
> Actually, mainline still supports legacy boot and has board files for
> OMAP3 platforms, and we shouldn't break legacy boot on purpose IMO.

It is not breaking anything. You'd have to call this function
mistakenly from a legacy machine desc or other non-DT boot path. It's
a question of how paranoid you are adding checks. IMHO, the BUG_ON is
quite pointless here. You are not likely to progress much further
anyway, and you won't see the BUG print because the serial port is not
up yet.

Rob
