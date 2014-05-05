Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaEEPei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:34:38 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:50808 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaEEPeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <13946837.RfnRDPQdge@wuerfel>
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
	<13946837.RfnRDPQdge@wuerfel>
Date: Mon, 5 May 2014 10:34:02 -0500
Message-ID: <CAL_JsqJXE4uXKA6XU1=3zFjdcEXHyUat2dL6wDKiZBx8S-p+Xg@mail.gmail.com>
Subject: Re: [PATCH 0/4] Introducing Exynos ChipId driver
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2014 at 10:02 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 03 May 2014 15:11:36 Pankaj Dubey wrote:
>> This patch series attempts to get rid of soc_is_exynosXXXX macros
>> and eventually with the help of this series we can probably get
>> rid of CONFIG_SOC_EXYNOSXXXX in near future.
>> Each Exynos SoC has ChipID block which can give information about
>> SoC's product Id and revision number. Currently we have single
>> DT binding information for this as "samsung,exynos4210-chipid".
>> But Exynos4 and Exynos5 SoC series have one small difference in
>> chip Id, with resepect to product id bit-masks. So it means we
>> should have separate compatible string for these different series
>> of SoCs. So I have created new binding information for handling
>> this difference. Also currently I can think of putting this driver
>> code under "drivers/misc/" but suggestions are welcome.
>> Also current form of driver is missing platfrom driver and needs
>> init function to be called from machine file (either exynos.c or
>> platsmp.c). I hope lot of suggestions and comments to improve this
>> further.
>>
>> This patch series is based on Kukjin Kim's for-next (3.14_rc1 tag)
>> and prepared on top of following patch series and it's dependent
>> patch series.
>
> I think putting it into drivers/soc would be most appropriate.
> We already have a few drivers lined up that we want in there,
> although the directory currently doesn't exist.
>
> However, I would ask that you use the infrastructure provided by
> drivers/base/soc.c when you add this driver, to also make the
> information available to user space using a standard API.

Agreed.

> Ideally this should be done by slightly restructuring the DT
> source to make all on-chip devices appear below the soc node.
> We'd have to think a bit about how to best do this while
> preserving compatibility with existing dts files.

I don't agree. How is a block with chip ID info the parent of all the
other devices?

In doing some work to move default of_platform_populate out of
platforms, I noticed that most platforms using the soc device are
making it the parent of platform devices. I think this is either wrong
or all platforms should have a default soc device. It makes little
sense for some platforms to have a devices under a soc sysfs directory
while others do not. Or the location changes when a platform latter
adds the soc device.

Rob
