Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaGKECi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 00:02:38 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42157 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaGKECg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 00:02:36 -0400
MIME-Version: 1.0
In-Reply-To: <53BF41C8.4080304@collabora.co.uk>
References: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk>
	<1404505467-26526-9-git-send-email-javier.martinez@collabora.co.uk>
	<CADGdYn6tyTBZOjZH8JBUVMJ1kh-tht=tkU4tA+oM=PbfTYkqGw@mail.gmail.com>
	<53BF41C8.4080304@collabora.co.uk>
Date: Thu, 10 Jul 2014 21:02:35 -0700
X-Google-Sender-Auth: zpfwwukdT6vsEscbBLWQPmeIVGk
Message-ID: <CAD=FV=XrgKSaOOutRr6wkNa6vu3uXo3ny43zyKCQzbYpe5xb2A@mail.gmail.com>
Subject: Re: [PATCH v7 08/24] mfd: max77686: Add Dynamic Voltage Scaling (DVS) support
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: amit daniel kachhap <amit.daniel@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Andreas Farber <afaerber@suse.de>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 10, 2014 at 6:45 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
>> I think when DVS gpio is used all the 8 voltage levels are fetched
>> from DT during booting and the registers are programmed accordingly.
>> Any further set/get_voltage just changes the GPIO lines.
>> Any reason why this method is not used?
>
> What are you describing is how the DT binding works for other Maxim PMICs that
> also have DVS support right? (e.g: max8997).
>
> The DVS binding in max77686/802 is actually a subset of the one in max8997 so it
> let's you only choose which single DVS index is going to be used. The GPIOs in
> "max77686,pmic-buck-dvs-gpios" should match "pmic-buck-default-dvs-idx".
>
> To be honest I just took the DT binding that was used in the max77xxx driver
> from the Chrome OS 3.8 kernel and didn't compare it with other Maxim PMICs DT
> bingings.
>
> I wonder if I should just take the DVS patches out from this initial version to
> avoid blocking the max77802 support and then we can discuss this in more detail.

To give background:

* On exynos5250 / exynos5420 / exynos5800 the CPUFreq driver exposes
more than 8 different operating points.  You could argue about whether
that's useful but that's the way it is right now.  That means that
using the GPIOs is not trivial (you'd have to use a mix of GPIOs and
i2c and use heuristics).

* On the Samsung Chromebook 2 we use the DVFS GPIOs to get back to a
sane state after a warm reset.  When the CPU resets itself all GPIOs
will default back to their reset state.  That will effectively
transfer us to DVFS slot 0.  We make sure that the kernel always
modifies a different DVFS slot.

* On all known boards all DVFS GPIOs were hooked up.  I originally
wrote code assuming that someone could design a board with fewer lines
hooked up but I don't know of that being done.

-Doug
