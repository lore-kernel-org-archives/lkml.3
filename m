Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbaCMNiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:38:05 -0400
Received: from smtp-out-088.synserver.de ([212.40.185.88]:1096 "EHLO
	smtp-out-042.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751154AbaCMNiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:38:03 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11748
Message-ID: <5321B4DD.5040306@metafoo.de>
Date: Thu, 13 Mar 2014 14:38:37 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, joelf@ti.com,
        nsekhar@ti.com, Liam Girdwood <lgirdwood@gmail.com>,
        Jyri Sarha <jsarha@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@kernel.org>, mporter@linaro.org,
        dan.j.williams@intel.com, vinod.koul@intel.com
Subject: Re: [alsa-devel] [PATCH 14/18] ASoC: davinci: Add edma dmaengine
 platform driver
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com> <1394702320-21743-15-git-send-email-peter.ujfalusi@ti.com> <53218835.3080909@metafoo.de> <5321AC84.7080004@ti.com>
In-Reply-To: <5321AC84.7080004@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 02:03 PM, Peter Ujfalusi wrote:
> On 03/13/2014 12:28 PM, Lars-Peter Clausen wrote:
>>> +int edma_pcm_platform_register(struct device *dev)
>>> +{
>>> +    if (dev->of_node)
>>> +        return snd_dmaengine_pcm_register(dev,
>>> +                    &edma_dmaengine_pcm_config,
>>> +                    SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
>>
>> Since the edma dmaengine driver implements the slave cap API there is no need
>> to manually specify SND_DMAENGINE_PCM_FLAG_NO_RESIDUE manually. But since the
>> edma driver sets the granularity to DMA_RESIDUE_GRANULARITY_DESCRIPTOR in this
>> case the generic dmaengine will not set SND_DMAENGINE_PCM_FLAG_NO_RESIDUE
>> automatically since it assumes that the dmaengine driver is capable of
>> properly reporting the DMA position.
>
> Hrm, I see. For eDMA I think we can support DMA_RESIDUE_GRANULARITY_SEGMENT
> granularity. Since according to the documentation the _SEGMENT means that the
> DMA position will be updated per periods, which is basically the same thing
> what we are doing at the moment when the granularity is
> DMA_RESIDUE_GRANULARITY_DESCRIPTOR.
>  From ALSA point of view at least they are the same: neither of them can report
> exact position, the DMA pointer jumps from period to period.
>
> IMHO in the generic dmaengine PCM we should set the SNDRV_PCM_INFO_BATCH for
> both cases.
>

Ups, sorry mixed up DMA_RESIDUE_GRANULARITY_SEGMENT and 
DMA_RESIDUE_GRANULARITY_DESCRIPTOR. You can just remove the 
SND_DMAENGINE_PCM_FLAG_NO_RESIDUE when registering the dmaengine PCM driver 
and everything will still work as expected.
