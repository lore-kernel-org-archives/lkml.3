Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbaCMMI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:08:58 -0400
Received: from smtp-out-079.synserver.de ([212.40.185.79]:1566 "EHLO
	smtp-out-042.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753981AbaCMMI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:08:56 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20777
Message-ID: <53219FFA.3030204@metafoo.de>
Date: Thu, 13 Mar 2014 13:09:30 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: davinci-linux-open-source@linux.davincidsp.com,
        alsa-devel@alsa-project.org, joelf@ti.com, vinod.koul@intel.com,
        nsekhar@ti.com, linux-kernel@vger.kernel.org,
        Jyri Sarha <jsarha@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Mark Brown <broonie@kernel.org>,
        mporter@linaro.org, dmaengine@vger.kernel.org,
        dan.j.williams@intel.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 14/18] ASoC: davinci: Add edma dmaengine
 platform driver
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com> <1394702320-21743-15-git-send-email-peter.ujfalusi@ti.com> <53218835.3080909@metafoo.de> <53219D08.9070308@ti.com>
In-Reply-To: <53219D08.9070308@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 12:56 PM, Peter Ujfalusi wrote:
> On 03/13/2014 12:28 PM, Lars-Peter Clausen wrote:
>> On 03/13/2014 10:18 AM, Peter Ujfalusi wrote: [...]
>>> +static const struct snd_pcm_hardware edma_pcm_hardware = { +    .info
>>> = SNDRV_PCM_INFO_MMAP | +                  SNDRV_PCM_INFO_MMAP_VALID | +
>>> SNDRV_PCM_INFO_BATCH | +                  SNDRV_PCM_INFO_PAUSE |
>>> SNDRV_PCM_INFO_RESUME | +                  SNDRV_PCM_INFO_INTERLEAVED, +
>>> .buffer_bytes_max    = 128 * 1024, +    .period_bytes_min    = 32, +
>>> .period_bytes_max    = 64 * 1024, +    .periods_min        = 2, +
>>> .periods_max        = 19, /* Limit by edma dmaengine driver */ +};
>>
>> The idea is that we can auto-discover all the things using the
>> dma_slave_caps API. Too bad we removed the possibility to specify the
>> maximum number of segments from the API. Maybe we need to add it back. Is
>> the 19 a hard-limit or could it be worked around by software in the
>> dmaengine driver?
>
> The edma dmaengine driver will refuse to configure more than 20 paRAM slots (1
> for the channel + 19 for the periods). Depending on the SoC we might have
> different number of paRAM entries available. The intention with the limit was
> to prevent cases when we run out of paRAM entires for other devices because
> audio took most of them.

The reason why we removed the max_segments field from the slave_caps struct 
was because we though it should be possible to, even when the hardware only 
supports a fixed amount of segments, emulate support for more in software. 
If this is not the case with the edma, we need to bring this field back.

