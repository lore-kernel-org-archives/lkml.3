Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaESDK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 23:10:26 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:49602 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaESDKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 23:10:24 -0400
MIME-Version: 1.0
In-Reply-To: <537513A8.701@metafoo.de>
References: <1400037830-21211-1-git-send-email-tushar.behera@linaro.org>
	<CABb+yY3YocX=8Dv7DysM4tcx=NTCCGGipz_gpMfpKDnAw7R8iw@mail.gmail.com>
	<CAHbNUh0fVND_oGLXWzsyKzbmJc_=FqhZTAnVHE4GGZ5aaJQbEg@mail.gmail.com>
	<5373607D.2000200@metafoo.de>
	<CAHbNUh1bmBniGVtvK4PpmpaKOnwG=MgtupkTEnjD6SS3r_-yjw@mail.gmail.com>
	<537513A8.701@metafoo.de>
Date: Mon, 19 May 2014 08:40:23 +0530
Message-ID: <CAHbNUh03oOHtLVzw7LiZ8SSR77D7ttLV9XDWS0px-8GTjSpJ4A@mail.gmail.com>
Subject: Re: [PATCH] dma: pl330: Add support for DMA_PAUSE command
From: Tushar Behera <tushar.behera@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-ALSA <alsa-devel@alsa-project.org>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2014 00:51, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 05/15/2014 02:01 PM, Tushar Behera wrote:
>>
>> On 14 May 2014 17:54, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>>
>>> On 05/14/2014 02:07 PM, Tushar Behera wrote:
>>>>
>>>>
>>>> On 14 May 2014 17:29, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>>>>>
>>>>>
>>>>> On Wed, May 14, 2014 at 8:53 AM, Tushar Behera
>>>>> <tushar.behera@linaro.org>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>> While playing back audio, pmc_dmaengine requests the DMA channel to
>>>>>> stop DMA transmission through DMA_PAUSE command.
>>>>>>
>>>>>> Currently PL330 driver doesn't support DMA pause command, leaving
>>>>>> the DMA state inconsistent when the system resumes. Instead, it would
>>>>>> be better to terminate the DMA transfer during suspend and restart
>>>>>> again during resume.
>>>>>>
>>>>>> Tested with audio playback across a suspend-resume cycle.
>>>>>>
>>>>> What is pmc_dmaengine? How does DMA_PAUSE help, when there is no
>>>>> DMA_RESUME?
>>>>>
>>>>
>>>> Sorry, it is a typo.
>>>>
>>>> sound/core/pcm_dmaengine.c:snd_dmaengine_pcm_trigger() -->
>>>> dmaengine_pause() is called during system suspend.
>>>
>>>
>>>
>>> It is only called if the DMA driver has support for pausing and resuming
>>> DMA
>>> transfers. Or at least that is the intention.
>>>
>>> - Lars
>>
>>
>> During suspend, snd_dmaengine_pcm_trigger():SNDRV_PCM_TRIGGER_SUSPEND
>> is called which unconditionally calls dmaengine_pause(). Should we
>> update snd_dmaengine_pcm_trigger() to check for DMA pause/resume
>> support and call dmaengine_pause() or dmaengine_terminate_all()
>> accordingly?
>
>
> As far as I understand it we do not have to do anything for TRIGGER_SUSPEND
> if we do not set the SNDRV_PCM_INFO_RESUME flag. It looks like
> TRIGGER_SUSPEND is called unconditionally during suspend. But since the
> error code is ignored it should be fine if we just call dmaengine_pause()
> and that return -ENOSYS or similar.
>
> Are you seeing an actual issue that you are trying to fix with your patch?
>
> - Lars
>

Without this patch applied, if audio is playing back while suspend is
triggered, it doesn't playback after resume. Stopping the stream and
replaying works.

-- 
Tushar Behera
