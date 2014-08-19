Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaHSKji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:39:38 -0400
Received: from smtp-out-151.synserver.de ([212.40.185.151]:1194 "EHLO
	smtp-out-134.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750721AbaHSKjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:39:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22355
Message-ID: <53F32965.8000302@metafoo.de>
Date: Tue, 19 Aug 2014 12:39:33 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
CC: "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "xobs@kosagi.com" <xobs@kosagi.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "timur@tabi.org" <timur@tabi.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: remove dependence
 of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
References: <cover.1408350626.git.shengjiu.wang@freescale.com>	<f30ba4e2c4eb6702fa40bd255036e6e9ad6eb47d.1408350626.git.shengjiu.wang@freescale.com>	<53F22F5E.2090601@metafoo.de>	<20140819074103.GA5806@audiosh1>	<d7b06608abcc4f098789f63cb9f36eef@BN1PR0301MB0609.namprd03.prod.outlook.com>	<20140819082108.GB5806@audiosh1>	<3a0c98ca698e4d38b3e92f339049b883@BN1PR0301MB0609.namprd03.prod.outlook.com> <s5hha184viu.wl-tiwai@suse.de>
In-Reply-To: <s5hha184viu.wl-tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 12:35 PM, Takashi Iwai wrote:
> At Tue, 19 Aug 2014 09:00:06 +0000,
> Li.Xiubo@freescale.com wrote:
>>
>> How about the following :
>>
>>
>> diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
>> index 5ae777a..d42f18c 100644
>> --- a/sound/soc/fsl/Kconfig
>> +++ b/sound/soc/fsl/Kconfig
>> @@ -15,7 +15,7 @@ config SND_SOC_FSL_ASRC
>>   config SND_SOC_FSL_SAI
>>          tristate "Synchronous Audio Interface (SAI) module support"
>>          select REGMAP_MMIO
>> -       select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
>> +       select SND_SOC_IMX_PCM_DMA
>>          select SND_SOC_GENERIC_DMAENGINE_PCM
>>          help
>>            Say Y if you want to add Synchronous Audio Interface (SAI)
>> @@ -25,7 +25,7 @@ config SND_SOC_FSL_SAI
>>
>>   config SND_SOC_FSL_SSI
>>          tristate "Synchronous Serial Interface module support"
>> -       select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
>> +       select SND_SOC_IMX_PCM_DMA
>>          select SND_SOC_IMX_PCM_FIQ if SND_IMX_SOC != n && (MXC_TZIC || MXC_AVIC)
>>          select REGMAP_MMIO
>>          help
>> @@ -37,7 +37,7 @@ config SND_SOC_FSL_SSI
>>   config SND_SOC_FSL_SPDIF
>>          tristate "Sony/Philips Digital Interface module support"
>>          select REGMAP_MMIO
>> -       select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
>> +       select SND_SOC_IMX_PCM_DMA
>>          select SND_SOC_IMX_PCM_FIQ if SND_IMX_SOC != n && (MXC_TZIC || MXC_AVIC)
>>          help
>>            Say Y if you want to add Sony/Philips Digital Interface (SPDIF)
>> @@ -48,7 +48,7 @@ config SND_SOC_FSL_SPDIF
>>   config SND_SOC_FSL_ESAI
>>          tristate "Enhanced Serial Audio Interface (ESAI) module support"
>>          select REGMAP_MMIO
>> -       select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
>> +       select SND_SOC_IMX_PCM_DMA
>>          help
>>            Say Y if you want to add Enhanced Synchronous Audio Interface
>>            (ESAI) support for the Freescale CPUs.
>> @@ -76,6 +76,7 @@ config SND_SOC_FSL_ASOC_CARD
>>
>>   config SND_SOC_IMX_PCM_DMA
>>          tristate
>> +       depends on SND_IMX_SOC
>>          select SND_SOC_GENERIC_DMAENGINE_PCM
>>
>>   config SND_SOC_IMX_AUDMUX
>
> I see the problem has been addressed, so JFYI: a reverse selection
> doesn't resolve "depends on".  It's a known shortcoming.  That is, a
> selected item can select further others, but cannot depend on others.

The item will still be selected regardless of its dependencies, but Kconfig 
will print a warning if one or more of the dependencies are not met along 
with the dependency chain that causes the warning. So you'll have a clue why 
things go wrong.

- Lars

