Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaEOFTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:19:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34549 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaEOFTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:19:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140514221423.GC6215@mithrandir>
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
	<1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
	<20140514221423.GC6215@mithrandir>
Date: Thu, 15 May 2014 10:49:37 +0530
X-Google-Sender-Auth: IfukZLmm59YmuMKZC6F_HEzvlgM
Message-ID: <CAPdUM4NaLpN99JCJH3qMakSO3OG6ASjEuvvr_CnKv=gOiqfzMQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] phy: Add exynos-simple-phy driver
From: Rahul Sharma <rahul.sharma@samsung.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        sunil joshi <joshi@samsung.com>, Rahul Sharma <r.sh.open@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 15 May 2014 03:44, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Thu, May 15, 2014 at 12:47:21AM +0530, Rahul Sharma wrote:
> [...]
>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> [...]
>> +For "samsung,exynos4210-simple-phy" compatible PHYs the second cell in
>> +the PHY specifier identifies the PHY and the supported phys for exynos4210
>
> I think the specifier is only the part after the phandle, so this should
> probably be "... compatible PHYs the single cell specifier ..." or
> something equivalent.
>

ok. I will rephrase this line.

>> +are:
>> +  HDMI_PHY,
>> +  DAC_PHY,
>> +  ADC_PHY,
>> +  PCIE_PHY,
>> +  SATA_PHY.
>
> I think you need to specify the literal values here as well, since the
> binding must be fully self-contained. That is you can't rely on the DT
> binding to be bundled with the exynos-simple-phy.h header.
>

Ok. I will add that.

>> @@ -20,3 +20,4 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)       += phy-exynos4x12-usb2.o
>>  phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)        += phy-exynos5250-usb2.o
>>  obj-$(CONFIG_PHY_EXYNOS5_USBDRD)     += phy-exynos5-usbdrd.o
>>  obj-$(CONFIG_PHY_XGENE)                      += phy-xgene.o
>> +obj-$(CONFIG_EXYNOS_SIMPLE_PHY)              += exynos-simple-phy.o
>
> Perhaps this should be named phy-exynos-simple for consistency? Also it
> may be a good idea to sort this alphabetically to reduce the potential
> for conflicts.

yea correct. I will use "phy-exynos-simple".
I will place this addition in alphabetical order in makefile.

>
>> +static int exynos_phy_probe(struct platform_device *pdev)
>> +{
>> +     const struct of_device_id *of_id = of_match_device(
>> +             of_match_ptr(exynos_phy_of_match), &pdev->dev);
>
> Why does this need of_match_ptr()?
>

yea correct. Not required.

>> +     dev_info(dev, "probe success\n");
>
> If at all this should be dev_dbg(). But in general the driver core will
> already complain if the driver fails to probe, so there's in general no
> need to mention when it probes successfully.
>

ok.

>> diff --git a/include/dt-bindings/phy/exynos-simple-phy.h b/include/dt-bindings/phy/exynos-simple-phy.h
> [...]
>> +/* simeple phys */
>
> s/simeple phys/simple PHYs/
>
> Although on second thought that comment probably shouldn't be there in
> the first place.
>
>> +#define INVALID      (~1)
>
> This doesn't belong in this header. The value should never be used by a
> DT source file, should it?

I will move this to driver file.
>
>> +#define HDMI_PHY     0
>> +#define DAC_PHY      1
>> +#define ADC_PHY      2
>> +#define PCIE_PHY     3
>> +#define SATA_PHY     4
>
> Perhaps these should be namespaced somehow to avoid potential conflicts
> with other PHY providers?

How about XXX_SIMPLE_PHY?

>
>> +#define PHY_NR       5
>
> I'm not sure that this belongs here either. It's not a value that will
> ever appear in a DT source file.

I want it to grow along with new additions in the phy list else
catastrophic. This will look unrelated in driver.

Regards,
Rahul Sharma.

>
> Thierry
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
