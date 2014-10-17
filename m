Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaJQOSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:18:24 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36227 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaJQOSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:18:22 -0400
Message-ID: <54412523.1030903@collabora.co.uk>
Date: Fri, 17 Oct 2014 16:18:11 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 5/7] regulator: max77802: Document regulator opmode
 DT properties
References: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk> <1413478133-2577-6-git-send-email-javier.martinez@collabora.co.uk> <20141017115701.GE1820@sirena.org.uk> <54410DF3.5020005@collabora.co.uk> <20141017135441.GR1820@sirena.org.uk>
In-Reply-To: <20141017135441.GR1820@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 10/17/2014 03:54 PM, Mark Brown wrote:
> On Fri, Oct 17, 2014 at 02:39:15PM +0200, Javier Martinez Canillas wrote:
> 
>> Just to be sure I understood correctly, are you suggesting something like this?
> 
>> 	ldo1_reg: LDO1 {
>> 		regulator-name = "vdd_1v0";
>> 		regulator-min-microvolt = <1000000>;
>> 		regulator-max-microvolt = <1000000>;
>> 		regulator-state-mem {
>> 			regulator-on-in-suspend;
>> 			regulator-mode = <MAX77802_OPMODE_LP>;
>> 		};
>> 	};
> 
>> In other words, extending Chanwoo Choi's original suspend state binding to add
>> the regulator-mode property that was present in his v3 [0] but instead trying
>> to use the standard REGULATOR_MODE_*, say that each regulator driver should
>> define it's own device-specific set of modes and a do the translation to fill
>> standard modes in the struct regulation_constraints {initial,disk,mem} mode?
> 
>> That way adding new suspend states, will only require changing the generic
>> regulator binding but not the regulator driver specific bindings.
> 
> Something like that, yes.  Not sure if numbers or strings are the best

Perfect will re-spin then, many thanks again for your feedback and suggestions.

> way of doing the mode but it probably doesn't matter too much now we
> have preprocessor support for inclue files.
> 

I usually prefer to avoid strings when possible since a typo can't be
detected when building the DTB and could be hard to debug at runtime while
a typo on a macro will be detected by the preprocessor at build time.

But I don't have a strong opinion either.

Best regards,
Javier
