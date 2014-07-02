Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaGBOKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:10:16 -0400
Received: from smtp-out-155.synserver.de ([212.40.185.155]:1231 "EHLO
	smtp-out-155.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaGBOKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:10:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7392
Message-ID: <53B412C1.20406@metafoo.de>
Date: Wed, 02 Jul 2014 16:10:09 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: alsa-devel@alsa-project.org, vinod.koul@intel.com, nsekhar@ti.com,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        joelf@ti.com, Mark Brown <broonie@kernel.org>,
        dmaengine@vger.kernel.org, dan.j.williams@intel.com
Subject: Re: [alsa-devel] [PATCH v2 3/5] ASoC: generic-dmaengine-pcm: Prepare
 formats mask for valid physical sample sizes
References: <1404307763-30557-1-git-send-email-peter.ujfalusi@ti.com> <1404307763-30557-4-git-send-email-peter.ujfalusi@ti.com> <s5h61jf6fec.wl%tiwai@suse.de>
In-Reply-To: <s5h61jf6fec.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 03:47 PM, Takashi Iwai wrote:
[...]
>> +	/*
>> +	 * Prepare formats mask for valid/allowed sample types. If the dma does
>> +	 * not have support for the given physical word size, it needs to be
>> +	 * masked out so user space can not use the format which produces
>> +	 * corrupted audio.
>> +	 * In case the dma driver does not implement the slave_caps the default
>> +	 * assumption is that it supports 1, 2 and 4 bytes widths.
>> +	 */
>> +	for (i = 0; i <= SNDRV_PCM_FORMAT_LAST; i++) {
>> +		int bits = snd_pcm_format_physical_width(i);
>
> Better to add a negative value check.  Some formats return -EINVAL.
>

So what should we do with those formats? Not support them?

>> +
>> +		/* Enable only samples with DMA supported physical widths */
>> +		if (addr_widths & BIT(bits / 8))
>
> Just nitpicking: Using BIT() for 32bit int isn't always a wise choice
> since BIT() is defined as unsigned long.  This is a generic problem,
> though, as we see many codes using BIT() wrongly (and thus get
> compiler warnings on 64bit machines).  We should introduce a new macro
> for 32bit int...

