Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaETVWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:22:55 -0400
Received: from smtp-out-147.synserver.de ([212.40.185.147]:1045 "EHLO
	smtp-out-146.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750808AbaETVWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:22:54 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 11517
Message-ID: <537BC744.8020601@metafoo.de>
Date: Tue, 20 May 2014 23:21:08 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, linux-samsung-soc@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH] Fix for possible null pointer dereference
 in dma.c
References: <1400191076-28279-1-git-send-email-rickard_strandqvist@spectrumdigital.se>	<5379E284.7030700@gmail.com> <CAFo99gZ3kVGn04we5OtRtbkceYRs6SiHXRyoX1Gb-SknJH=z=w@mail.gmail.com> <537BAA2B.9090906@gmail.com>
In-Reply-To: <537BAA2B.9090906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 09:16 PM, Tomasz Figa wrote:
> Hi Rickard,
>
> On 20.05.2014 21:12, Rickard Strandqvist wrote:
>> Hi Tomasz
>>
>> What I based my patch on is really because of this line:
>> if (substream)
>>           snd_pcm_period_elapsed(substream);
>>
>> Boojin Kim thought that this was needed, if this is true anymore..? I
>> have not been able to immerse myself so much in all patches.
>> I'm working on about 100 similar patches.
>
> To me having NULL as either data argument of buffer done callback or
> private_data would be a serious driver bug and IMHO it's better to let
> it crash with a NULL pointer dereference to let someone notice than mask
> it by adding a condition.
>
> Still, I'm not too experienced with ALSA and ASoC, so I might be wrong.
> Mark, what do you think about this?

Given that there is a patch[1] which removes the whole file I think we can stop 
the discussion about this patch here.

But for the record, substream will never ever be NULL in this function. prtd 
might be though if the DMA completion callback races against the closing of the 
PCM stream.

[1] http://mailman.alsa-project.org/pipermail/alsa-devel/2014-May/076860.html

