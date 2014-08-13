Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaHMQQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:16:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57360 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaHMQQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:16:03 -0400
Message-ID: <53EB8F50.7090505@wwwdotorg.org>
Date: Wed, 13 Aug 2014 10:16:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ARM: dts: Add tps65090 FETs constraints
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk> <1407861868-20097-7-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1407861868-20097-7-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2014 10:44 AM, Javier Martinez Canillas wrote:
> The tps65090 PMU data manual [0] has a table that list the
> "Recommended operating conditions" for each regulator. Add
> the information about the FET constraints to its dtsi file.
>
> [0]: http://www.ti.com/lit/ds/symlink/tps65090.pdf

I'm worried that this file represents the limits of the PMIC itself, 
whereas the DT should be representing the limits of the circuits that 
the various PMIC regulators are attached to on the board.

For example:

> diff --git a/arch/arm/boot/dts/tps65090.dtsi b/arch/arm/boot/dts/tps65090.dtsi

>   		tps65090_fet3: fet3 {
> +			regulator-min-microvolt = <3000000>;
> +			regulator-max-microvolt = <5500000>;
>   		};

I guess that on some boards, this output rail might be attached to 
devices that must run at 3.3V exactly, and on other boards it might be 
attached to devices that must run at 5V exactly. The DT for those two 
boards should each have regulator-{min,max}-microvolt set to the same 
value, which describes the board requirements.

It feels dangerous/misleading to define the PMIC range by default. It 
might lead people to think that since the property already has a defined 
value, they don't need to think about what the correct value for their 
board is, and hence not change the value in their board file.
