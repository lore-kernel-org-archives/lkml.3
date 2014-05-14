Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaENM0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:26:21 -0400
Received: from smtp-out-164.synserver.de ([212.40.185.164]:1087 "EHLO
	smtp-out-123.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751527AbaENM0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:26:19 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 18873
Message-ID: <5373607D.2000200@metafoo.de>
Date: Wed, 14 May 2014 14:24:29 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
CC: Jassi Brar <jassisinghbrar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dma: pl330: Add support for DMA_PAUSE command
References: <1400037830-21211-1-git-send-email-tushar.behera@linaro.org> <CABb+yY3YocX=8Dv7DysM4tcx=NTCCGGipz_gpMfpKDnAw7R8iw@mail.gmail.com> <CAHbNUh0fVND_oGLXWzsyKzbmJc_=FqhZTAnVHE4GGZ5aaJQbEg@mail.gmail.com>
In-Reply-To: <CAHbNUh0fVND_oGLXWzsyKzbmJc_=FqhZTAnVHE4GGZ5aaJQbEg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 02:07 PM, Tushar Behera wrote:
> On 14 May 2014 17:29, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>> On Wed, May 14, 2014 at 8:53 AM, Tushar Behera <tushar.behera@linaro.org> wrote:
>>> While playing back audio, pmc_dmaengine requests the DMA channel to
>>> stop DMA transmission through DMA_PAUSE command.
>>>
>>> Currently PL330 driver doesn't support DMA pause command, leaving
>>> the DMA state inconsistent when the system resumes. Instead, it would
>>> be better to terminate the DMA transfer during suspend and restart
>>> again during resume.
>>>
>>> Tested with audio playback across a suspend-resume cycle.
>>>
>> What is pmc_dmaengine? How does DMA_PAUSE help, when there is no DMA_RESUME?
>>
>
> Sorry, it is a typo.
>
> sound/core/pcm_dmaengine.c:snd_dmaengine_pcm_trigger() -->
> dmaengine_pause() is called during system suspend.

It is only called if the DMA driver has support for pausing and resuming DMA 
transfers. Or at least that is the intention.

- Lars
