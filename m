Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaGBOOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:14:05 -0400
Received: from smtp-out-155.synserver.de ([212.40.185.155]:1042 "EHLO
	smtp-out-155.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbaGBOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:14:01 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14206
Message-ID: <53B413A7.6070301@metafoo.de>
Date: Wed, 02 Jul 2014 16:13:59 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, alsa-devel@alsa-project.org,
        vinod.koul@intel.com, nsekhar@ti.com,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        joelf@ti.com, Mark Brown <broonie@kernel.org>,
        dmaengine@vger.kernel.org, dan.j.williams@intel.com
Subject: Re: [alsa-devel] [PATCH v2 3/5] ASoC: generic-dmaengine-pcm: Prepare
 formats mask for valid physical sample sizes
References: <1404307763-30557-1-git-send-email-peter.ujfalusi@ti.com>	<1404307763-30557-4-git-send-email-peter.ujfalusi@ti.com>	<s5h61jf6fec.wl%tiwai@suse.de>	<53B412C1.20406@metafoo.de> <s5h38ej6e8y.wl%tiwai@suse.de>
In-Reply-To: <s5h38ej6e8y.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 04:12 PM, Takashi Iwai wrote:
> At Wed, 02 Jul 2014 16:10:09 +0200,
> Lars-Peter Clausen wrote:
>>
>> On 07/02/2014 03:47 PM, Takashi Iwai wrote:
>> [...]
>>>> +	/*
>>>> +	 * Prepare formats mask for valid/allowed sample types. If the dma does
>>>> +	 * not have support for the given physical word size, it needs to be
>>>> +	 * masked out so user space can not use the format which produces
>>>> +	 * corrupted audio.
>>>> +	 * In case the dma driver does not implement the slave_caps the default
>>>> +	 * assumption is that it supports 1, 2 and 4 bytes widths.
>>>> +	 */
>>>> +	for (i = 0; i <= SNDRV_PCM_FORMAT_LAST; i++) {
>>>> +		int bits = snd_pcm_format_physical_width(i);
>>>
>>> Better to add a negative value check.  Some formats return -EINVAL.
>>>
>>
>> So what should we do with those formats? Not support them?
>
> Yes, these are special formats that can't be handled generically.
>

Looking through the list in pcm_misc.c there are also some formats where the 
physical width is not a multiple of 8. We should probably also skip those.

- Lars

