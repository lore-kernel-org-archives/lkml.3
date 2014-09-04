Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbaIDA7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 20:59:47 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59165 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813AbaIDA7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 20:59:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAL8zT=j0TfC=RaA5L+Zm3ACk=D57tb+k6HNrQnSjd4JY_iupCQ@mail.gmail.com>
References: <1409672977-26972-1-git-send-email-jean-michel.hautbois@vodalys.com>
	<CAPDyKFrwCzQJvbpbue4T=HWLmbq5sZOP3RXwiupKvXe71uboUw@mail.gmail.com>
	<5406D942.4080405@intel.com>
	<CAPDyKFrnF4biUGkLgkzz2RNdY1yLp2_bfvoWMM55yx-_TG6ENw@mail.gmail.com>
	<CAL8zT=j0TfC=RaA5L+Zm3ACk=D57tb+k6HNrQnSjd4JY_iupCQ@mail.gmail.com>
Date: Thu, 4 Sep 2014 08:59:42 +0800
Message-ID: <CAC1bqKjV1kEb2vL=Vo_tO9XqPh11OdPGwpUooETnK0yXOYw6SQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: Enable boot partition access from DT
From: Hsin-Hsiang Tseng <hsinhsiangtseng@gmail.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <b29396@freescale.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>, h80.chung@samsung.com,
        Chris Ball <chris@printf.net>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jean-Michel
Some platforms which using Samsung exynos SoC, we write u-boot related
bin files in boot partitions(in my case boot partition 1) to boot on
eMMC.
Some platforms which using Qualcomm SoC, written at logical address
0(User Data Area) and they use a-boot not u-boot.
BTW, rpmb partition is not wide use now. As i know, some Intel
platforms have use rpmb partition.

Thanks,
Hsinhsiang

2014-09-03 21:08 GMT+08:00 Jean-Michel Hautbois
<jean-michel.hautbois@vodalys.com>:
> 2014-09-03 11:09 GMT+02:00 Ulf Hansson <ulf.hansson@linaro.org>:
>> On 3 September 2014 11:02, Adrian Hunter <adrian.hunter@intel.com> wrote:
>>> On 09/03/2014 11:30 AM, Ulf Hansson wrote:
>>>> On 2 September 2014 17:49, Jean-Michel Hautbois
>>>> <jean-michel.hautbois@vodalys.com> wrote:
>>>>> This property is useful when we don't want to access boot partitions on eMMC
>>>>>
>>>>> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>>>>> ---
>>>>>  Documentation/devicetree/bindings/mmc/mmc.txt | 1 +
>>>>>  drivers/mmc/host/sdhci-esdhc-imx.c            | 8 ++++++++
>>>>>  include/linux/platform_data/mmc-esdhc-imx.h   | 1 +
>>>>>  3 files changed, 10 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
>>>>> index 431716e..59cc854 100644
>>>>> --- a/Documentation/devicetree/bindings/mmc/mmc.txt
>>>>> +++ b/Documentation/devicetree/bindings/mmc/mmc.txt
>>>>> @@ -40,6 +40,7 @@ Optional properties:
>>>>>  - mmc-hs200-1_2v: eMMC HS200 mode(1.2V I/O) is supported
>>>>>  - mmc-hs400-1_8v: eMMC HS400 mode(1.8V I/O) is supported
>>>>>  - mmc-hs400-1_2v: eMMC HS400 mode(1.2V I/O) is supported
>>>>> +- no-boot-part : when preset, tells to access boot partitions
>>>>>
>>>>>  *NOTE* on CD and WP polarity. To use common for all SD/MMC host controllers line
>>>>>  polarity properties, we have to fix the meaning of the "normal" and "inverted"
>>>>> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
>>>>> index ccec0e3..439e663 100644
>>>>> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
>>>>> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
>>>>> @@ -942,6 +942,11 @@ sdhci_esdhc_imx_probe_dt(struct platform_device *pdev,
>>>>>         if (of_property_read_u32(np, "fsl,delay-line", &boarddata->delay_line))
>>>>>                 boarddata->delay_line = 0;
>>>>>
>>>>> +       if (of_find_property(np, "no-boot-part", NULL))
>>>>> +               boarddata->access_boot_part = false;
>>>>> +       else
>>>>> +               boarddata->access_boot_part = true;
>>>>> +
>>>>>         return 0;
>>>>>  }
>>>>>  #else
>>>>> @@ -1119,6 +1124,9 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
>>>>>                 host->quirks2 |= SDHCI_QUIRK2_NO_1_8_V;
>>>>>         }
>>>>>
>>>>> +       if (!boarddata->access_boot_part)
>>>>> +               host->mmc->caps2 |= MMC_CAP2_BOOTPART_NOACC;
>>>>> +
>>>>
>>>> Hmm, I don't think MMC_CAP2_BOOTPART_NOACC should have a DT binding.
>>>> Does it describe the hardware in some form?
>>>>
>>>> Actually I would like to question why MMC_CAP2_BOOTPART_NOACC exists
>>>> at all. If there are cards that don't supports the BOOT area,
>>>> shouldn't we have a card quirk for it instead of a host cap? Maybe
>>>> Adrian Hunter, how originally wrote the patch for adding
>>>> MMC_CAP2_BOOTPART_NOACC, could help me understand the reasons behind
>>>> it!?
>>>
>>> It was added because platform firmware was able to prevent access to the
>>> boot partitions (for security I think), so attempts to access them would
>>> fail messily.  It was not related to any specific card.
>>
>> Adrian, appreciate your clarification. After all it seems like adding
>> a DT binding for it should be appropriate.
>>
>> Kind regards
>> Uffe
>
> Thanks Adrian :).
> Well, there is boot partitions and rpmb partition, and maybe should we
> have a binding to prevent access to both of them ?
> Something else came to my mind, when you want to boot on eMMC, do you
> need to write u-boot in boot partitions or is it written at the
> logical adress 0 which is what fdisk uses as start ?
> Because, if this is not usuable but just scanned I can't see why we
> bother doing it... ?
>
> Thanks,
> JM
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
