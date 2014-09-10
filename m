Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaIJI71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:59:27 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35219 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaIJI7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:59:25 -0400
Message-ID: <541012E8.9010208@collabora.co.uk>
Date: Wed, 10 Sep 2014 10:59:20 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] ARM: dts: Add Peach Pit and Pi dts entry for max77802
 PMIC
References: <1408533593-32346-1-git-send-email-javier.martinez@collabora.co.uk>	<1408533593-32346-2-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=VVLmnvZToewvsiJDUbapPj5BBA=RG4a7_N9wadRN7CTg@mail.gmail.com>
In-Reply-To: <CAD=FV=VVLmnvZToewvsiJDUbapPj5BBA=RG4a7_N9wadRN7CTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 09/10/2014 06:42 AM, Doug Anderson wrote:
>> +
>> +                       ldo35_reg: LDO35 {
>> +                               regulator-name = "ldo_35";
>> +                               regulator-min-microvolt = <1200000>;
>> +                               regulator-max-microvolt = <1200000>;
>> +                               inl2-supply = <&buck7_reg>;
> 
> Is this a typo?  Shouldn't supplies be specified at the top?
>

Yes it is a left over from a previous attempt. The first time I looked at the
DT binding doc to see how parent supplies should be defined, the example said:

        xyzreg: regulator@0 {
                regulator-min-microvolt = <1000000>;
                regulator-max-microvolt = <2500000>;
                regulator-always-on;
                vin-supply = <&vin>;
        };

but that didn't work for me since the parent supplies are not parsed in
of_get_regulation_constraints() [0] but in regulator_register() [1] by calling
regulator_dev_lookup() passing the parent device.

So then I looked at other DTS and found that the supplies where indeed defined
on the top as properties of the "regulators" parent node so that's what I
used. I missed to remove the supply for this regulator, thanks a lot for noticing.

BTW, Documentation/devicetree/bindings/regulator/regulator.txt should be
changed to reflect that the supplies should not be defined in the regulator
node but in the parent node but that is unrelated to this patch of course.

> 
> Other than that, you can add my Reviewed-by.
> 

Best regards,
Javier

[0]: http://lxr.free-electrons.com/source/drivers/regulator/of_regulator.c#L19
[1]: http://lxr.free-electrons.com/source/drivers/regulator/core.c#L3506
