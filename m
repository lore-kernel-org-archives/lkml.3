Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaDUTf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 15:35:58 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:61652 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaDUTfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:35:50 -0400
MIME-Version: 1.0
In-Reply-To: <535560E9.5040108@wwwdotorg.org>
References: <1397757570-19750-1-git-send-email-dianders@chromium.org>
	<1397757570-19750-8-git-send-email-dianders@chromium.org>
	<535560E9.5040108@wwwdotorg.org>
Date: Mon, 21 Apr 2014 12:35:49 -0700
X-Google-Sender-Auth: yjB_SbRObM5T5pC044WiVisN7rU
Message-ID: <CAD=FV=W8=SLxF=goYm9p3Dr0ZQYy9FzN0hbE+MwWFYGarZB9tw@mail.gmail.com>
Subject: Re: [PATCH 7/7] ARM: tegra: Add the EC i2c tunnel to tegra124-venice2
From: Doug Anderson <dianders@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Olof Johansson <olof@lixom.net>,
        Simon Glass <sjg@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Mon, Apr 21, 2014 at 11:18 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/17/2014 11:59 AM, Doug Anderson wrote:
>> This adds the EC i2c tunnel (and devices under it) to the
>> tegra124-venice2 device tree.
>
> The series,
> Tested-by: Stephen Warren <swarren@nvidia.com>
>
> I can apply this one patch once the other patches in the series are
> acked or applied (in order to make sure the DT binding is acceptable to
> others).

Sounds good.  If I don't get any feedback (positive or negative) in
the next few days I'll resend with your Tested-by.


> I guess I'll send separate patches for tegra_defconfig and
> multi_v7_defconfig to add the required options once I've applied this,
> unless you beat me to it.
>
>> diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
>
>>       aliases {
>> +             i2c20 = "/spi@0,7000d400/cros-ec@0/i2c-tunnel";
>
> Is that needed? I'd prefer not to add it unless there's a specific
> reason. I don't think I2C buses need specific names, do they?

It is not strictly needed, but from a usability standpoint it is
terribly helpful.  It serves to make it obvious to someone looking at
the device that it's _not_ an i2c bus associated with the main SoC.
If you don't include a number I believe that the i2c core will pick
the first available number.

It seems worth it to save a few people a few hours of head scratching.

...but this is your dts and if you think it's a terrible idea then
I'll remove it.  It looks to be less critical on tegra than it is on
exynos (which has ~9 i2c busses, they are numbered in the user manual,
and if you have one set to "disable" in the dts then the tunnel will
end up getting a very confusing number).

-Doug
