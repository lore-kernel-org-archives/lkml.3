Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab3HLNCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:02:22 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:60258 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3HLNCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:02:20 -0400
Message-ID: <5208DCB7.9070103@elopez.com.ar>
Date: Mon, 12 Aug 2013 10:01:43 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] clk: sunxi: Add A31 clocks support
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com> <1375195462-19566-4-git-send-email-maxime.ripard@free-electrons.com> <20130812125357.GD6616@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130812125357.GD6616@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 12/08/13 09:53, Mark Rutland escribió:
> On Tue, Jul 30, 2013 at 03:44:21PM +0100, Maxime Ripard wrote:
>> The A31 has a mostly different clock set compared to the other older
>> SoCs currently supported in the Allwinner clock driver.
>>
>> Add support for the basic useful clocks. The other ones will come in
>> eventually.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>  drivers/clk/sunxi/clk-sunxi.c | 120 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 120 insertions(+)
>>
> 
> [...]
> 
>> @@ -420,6 +516,10 @@ static const __initconst struct of_device_id clk_factors_match[] = {
>>  		.data = &sun4i_pll1_data,
>>  	},
>>  	{
>> +		.compatible = "allwinner,sun6i-pll1-clk",
>> +		.data = &sun6i_pll1_data,
>> +	},
>> +	{
>>  		.compatible = "allwinner,sun4i-apb1-clk",
>>  		.data = &sun4i_apb1_data,
>>  	},
>> @@ -440,6 +540,10 @@ static const __initconst struct of_device_id clk_div_match[] = {
>>  		.compatible = "allwinner,sun4i-apb0-clk",
>>  		.data = &sun4i_apb0_data,
>>  	},
>> +	{
>> +		.compatible = "allwinner,sun6i-apb2-div-clk",
>> +		.data = &sun6i_apb2_div_data,
>> +	},
>>  	{}
>>  };
>>  
>> @@ -453,6 +557,10 @@ static const __initconst struct of_device_id clk_mux_match[] = {
>>  		.compatible = "allwinner,sun4i-apb1-mux-clk",
>>  		.data = &sun4i_apb1_mux_data,
>>  	},
>> +	{
>> +		.compatible = "allwinner,sun6i-ahb1-mux-clk",
>> +		.data = &sun6i_ahb1_mux_data,
>> +	},
>>  	{}
>>  };
>>  
>> @@ -471,6 +579,10 @@ static const __initconst struct of_device_id clk_gates_match[] = {
>>  		.data = &sun5i_a13_ahb_gates_data,
>>  	},
>>  	{
>> +		.compatible = "allwinner,sun6i-a31-ahb1-gates-clk",
>> +		.data = &sun6i_a31_ahb1_gates_data,
>> +	},
>> +	{
>>  		.compatible = "allwinner,sun4i-apb0-gates-clk",
>>  		.data = &sun4i_apb0_gates_data,
>>  	},
>> @@ -486,6 +598,14 @@ static const __initconst struct of_device_id clk_gates_match[] = {
>>  		.compatible = "allwinner,sun5i-a13-apb1-gates-clk",
>>  		.data = &sun5i_a13_apb1_gates_data,
>>  	},
>> +	{
>> +		.compatible = "allwinner,sun6i-a31-apb1-gates-clk",
>> +		.data = &sun6i_a31_apb1_gates_data,
>> +	},
>> +	{
>> +		.compatible = "allwinner,sun6i-a31-apb2-gates-clk",
>> +		.data = &sun6i_a31_apb2_gates_data,
>> +	},
>>  	{}
>>  };
> 
> Could you please document these new strings? I assume they follow the
> general conventions of sunxi clocks thus far and the strings can just be
> appended to the lists in the existing binding document.

I believe they have been documented already on the latest version of
this patchset (v3 at the time of speaking)

Cheers,

Emilio
