Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaJUKA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:00:27 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41077 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaJUKA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:00:26 -0400
Message-ID: <54462EB2.2070302@collabora.co.uk>
Date: Tue, 21 Oct 2014 12:00:18 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
CC: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: exynos4412-trats: Add suspend configuration
 for max77686 regulators
References: <1413879912-26606-1-git-send-email-k.kozlowski@samsung.com> <1413879912-26606-3-git-send-email-k.kozlowski@samsung.com> <54461FC0.9020904@samsung.com> <1413883424.26980.7.camel@AMDC1943>
In-Reply-To: <1413883424.26980.7.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/21/2014 11:23 AM, Krzysztof Kozlowski wrote:
>> >  
>> >  				ldo9_reg: ldo9 {
>> > @@ -295,7 +311,9 @@
>> >  					regulator-name = "CAM_ISP_MIPI_1.2V";
>> >  					regulator-min-microvolt = <1200000>;
>> >  					regulator-max-microvolt = <1200000>;
>> > -					regulator-mem-idle;
>> > +					regulator-state-mem {
>> > +						regulator-on-in-suspend;
>> 
>> CAM_ISP_MIPI_1.2V is used for camera, I think this regulator should turn off in suspend state
>> because camear could not be used in suspend state.
> 
> LDO9 does not support off in suspend mode controlled by PWRREQ. It
> supports only switching to low power mode if PWRREQ level goes low.
> 
> Thus the driver does not provide set_suspend_enable or
> set_suspend_disable for LDO0. Do you want to add such function to the
> max77686 driver which will explicitly disable the regulator (write 0x0
> to control reg)?
> 
> 

I think for those regulators you can just use regulator_disable_regmap()
as the .set_suspend_disable function handler?

Best regards,
Javier
