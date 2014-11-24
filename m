Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaKXMnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:43:17 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38215 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaKXMnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:43:15 -0500
Message-ID: <547327DA.9090605@collabora.co.uk>
Date: Mon, 24 Nov 2014 13:43:06 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Vivek Gautam <gautamvivek1987@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>, Kukjin Kim <kgene@kernel.org>
Subject: Re: [PATCH V2 RESEND] arm: dts: Exynos5: Use pmu_system_controller
 phandle for dp phy
References: <1416807683-2257-1-git-send-email-gautam.vivek@samsung.com>	<20141124103249.GA26217@ulmo.nvidia.com>	<CAFp+6iE22FnHeXJZQyhytzGDNfnP4sdnYZuyFtmfzP_JVTVNPQ@mail.gmail.com>	<20141124105656.GA32478@ulmo.nvidia.com> <CAFp+6iFgXFL8=jvrdw4Z+vfPSzWO9FYxAHMD1Tr9wD0Sy=gHMg@mail.gmail.com>
In-Reply-To: <CAFp+6iFgXFL8=jvrdw4Z+vfPSzWO9FYxAHMD1Tr9wD0Sy=gHMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek, Thierry,

On 11/24/2014 12:29 PM, Vivek Gautam wrote:
>> Yes. Back at the time a decision was made that device trees need to be
>> stable ABI because eventually they'd be shipped with the device rather
>> than the distribution. As such it may not at all be possible to update
>> them (they could be in some sort of ROM).
>>
>> For that reason new kernels need to keep working with old DTBs unless an
>> argument can be made that would justify breaking things. I don't think I
>> have ever seen anyone win such an argument.

Although uncommon, there are cases when breaking a DT backward compatibility
could make sense IMHO. For example the DT binding for the SPI controller
found on Samsung SoCs (s3c64xx) used a custom binding to specify the chip
select (CS) line. Later the binding was changed in mainline breaking backward
compatibility and the breakage was not noticed in a year even when the change
not only broke backward compatibility but also was wrong.

So the options were to a) keep the buggy DT which also broke backward compact,
b) revert to the old binding breaking any DTS that were added the last year,
c) break backward compatibility again but take the opportunity to fix the
binding for good by dropping device specific bindings and use standard ones.

At the end it was decided that c) was the least bad option and was made in
commit 306972c ("spi: s3c64xx: use the generic SPI "cs-gpios" property").

>> One of the rare exceptions
>> that I know of is if you can prove that a given hardware block has never
>> been used in an upstream kernel, then changing the DTB in backwards-
>> incompatible ways would be okay because you wouldn't be breaking things
>> for existing users.
> 
> I am pretty sure about the Chrome devices (which have not been
> upgraded to any kernel after
> 3.8).
> Probably Javier may have better knowledge.
> 

Correct. The Exynos based Chromebooks are using a 3.8 kernel and the FDT
shipped can't be used with a mainline kernel since it used out-of-tree
drivers whose DT bindings were changed during review to upstream inclusion.

Also, the stock boot-loader loads a FIT image which has a kernel and FDT
bundled in the same image so in that case the FDT has to be shipped with
the Linux kernel anyways.

> Javier, is there any other device using upstream kernel post 3.12 (any
> arndale octa based) ?
> 

Sorry, I don't know if there are other Exynos devices using a more recent
kernel but AFAICT the DT binding for the Exynos Display Port was changed
recently (v3.17) in a non-backward compatible way with commit 5f1dcd8
("drm/exynos: dp: Modify driver to support drm_panel"). So anyone using a
more recent kernel will have to update the FDT to have display working.

Also display does not work for many Exynos5 devices that have an eDP to LVDS
bridge chip for example so I think is safe to assume that anything related
to the Exynos DP (like the DP PHY) would still not have a stable DT binding.

Best regards,
Javier
