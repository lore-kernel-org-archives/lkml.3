Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaF3QAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:00:15 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35684 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbaF3QAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:00:11 -0400
Message-ID: <53B18984.7010607@collabora.co.uk>
Date: Mon, 30 Jun 2014 18:00:04 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Stone <daniels@collabora.com>
Subject: Re: [PATCH v5 05/14] clk: Add generic driver for Maxim PMIC clocks
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk> <1403806546-31122-6-git-send-email-javier.martinez@collabora.co.uk> <CAKew6eU5X=WxhECtwUUwbXe_fCRU4bD6B7caWiA2dwcBfThd-g@mail.gmail.com> <53B142F1.1050407@collabora.co.uk> <20140630113539.GX32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140630113539.GX32514@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

Thanks a lot for your suggestion.

On 06/30/2014 01:35 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 30, 2014 at 12:58:57PM +0200, Javier Martinez Canillas wrote:
>> >> +       if (!max_gen->lookup)
>> >> +               return ERR_PTR(-ENOMEM);
>> >> +
>> >> +       max_gen->lookup->con_id = hw->init->name;
>> > 
>> > Also IMO,  init->name should be over-written if name is provided in DT,
>> > otherwise generic "clock-output-names" property will go futile,
>> > perhaps it should be done before clk_register.
>> > 
>> 
>> Even though Documentation/devicetree/bindings/clock/clock-bindings.txt says that
>> the "clock-output-names" property is optional I agree with you that will be
>> better to support it. So I'll add it on the next version as well.
> 
> However, remember that con_id is the _DEVICE_ specific connection name,
> not the _CLOCK_ name.  You will get a NAK from me if you violate this
> rule.
> 

Yes I know that con_id is the device specific connection name that is set by the
consumers using the "clock-names" property. But AFAIU the clk_lookup structs
added by clockdev_add() are only used by legacy non-DT drivers which don't set
their clock names and instead is the clock driver the one that set con_id to the
struct clk_init_data .name field.

I see that other drivers do the same, is that wrong as well? What value should
have con_id when registering clkdevs for legacy non-DT drivers?

DT enabled drivers whose devices define their "clock-names" are not affected by
this since the clock lookup is made by matching OF "clock-names" property + and
index.

Best regards,
Javier
