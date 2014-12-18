Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaLROLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:11:17 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50164 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaLROLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:11:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DzEe91pTv+UkCbj0DzgVDOb9hjuakt9NmpTJnEk-j8UA@mail.gmail.com>
References: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
	<1414729631-11005-5-git-send-email-tharvey@gateworks.com>
	<CAOMZO5DzEe91pTv+UkCbj0DzgVDOb9hjuakt9NmpTJnEk-j8UA@mail.gmail.com>
Date: Thu, 18 Dec 2014 06:11:15 -0800
Message-ID: <CAJ+vNU3PQYCE4tABUiqU+vGkGqBEqdVKz25W88-ByOQZxunVLw@mail.gmail.com>
Subject: Re: [PATCH 4/5] cpufreq: imx6q: add ldo-bypass support
From: Tim Harvey <tharvey@gateworks.com>
To: Fabio Estevam <festevam@gmail.com>, Mark Brown <broonie@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Christian Hemp <c.hemp@phytec.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Iain Paton <ipaton0@gmail.com>, Anson.Huang@freescale.com,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 6:36 AM, Fabio Estevam <festevam@gmail.com> wrote:
> Hi Tim,
>
> On Fri, Oct 31, 2014 at 2:27 AM, Tim Harvey <tharvey@gateworks.com> wrote:
>> When an external PMIC is used for VDD_SOC and VDD_ARM you can save power by
>> bypassing the internal LDO's provided by the anantop regulator as long as
>> you are running less than 1.2GHz. If running at 1.2GHz the IMX6 datasheets
>> state that you must use the internal LDO's to reduce ripple on the suplies.
>>
>> A failure to bypass the LDO's when using an external PMIC will result in an
>> extra voltage drop (~125mV) between VDD_ARM_IN and VDD_ARM and VDD_SOC_IN and
>> VDD_SOC which violates the voltages specificed by the datasheets.
>>
>> Cc: Philipp Zabel <p.zabel@pengutronix.de>
>> Cc: Shawn Guo <shawn.guo@freescale.com>
>> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
>> ---
>>  drivers/cpufreq/imx6q-cpufreq.c | 51 +++++++++++++++++++++++++++++++++++++++++
>
> Shouldn't the LDO bypass support be added into the anatop regulator
> driver instead?
>
> What if someone wants to use LDO bypass and not use the cpufreq driver?

Fabio,

That does make sense perhaps - I'm just not sure the best way to do it.

What is needed is to determine if the cpu vddsoc and vddarm regulators
are both 'not' the same as the anatop provided regulators (then we
bypass the anatop regulators) so I need to do such a check after all
regulators are registered. Perhaps I need to have a late_init call (or
some other init call that happens after all regulators are
registered).

Phillipp/Mark - what are your thoughts here? Do the regulator core
functions regulator_is_same() [1] and regulator_is_bypass() [2] I
propose make sense to determine if regulators are the same and in
bypass mode and overcome the detection issues Phillipp discussed in a
previous thread [3]?

[1] http://article.gmane.org/gmane.linux.kernel/1818320/
[2] http://article.gmane.org/gmane.linux.kernel/1818324/
[3] http://thread.gmane.org/gmane.linux.ports.arm.kernel/359856

Regards,

Tim
