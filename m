Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbaENMHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:07:06 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:52840 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaENMHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:07:04 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY3YocX=8Dv7DysM4tcx=NTCCGGipz_gpMfpKDnAw7R8iw@mail.gmail.com>
References: <1400037830-21211-1-git-send-email-tushar.behera@linaro.org>
	<CABb+yY3YocX=8Dv7DysM4tcx=NTCCGGipz_gpMfpKDnAw7R8iw@mail.gmail.com>
Date: Wed, 14 May 2014 17:37:03 +0530
Message-ID: <CAHbNUh0fVND_oGLXWzsyKzbmJc_=FqhZTAnVHE4GGZ5aaJQbEg@mail.gmail.com>
Subject: Re: [PATCH] dma: pl330: Add support for DMA_PAUSE command
From: Tushar Behera <tushar.behera@linaro.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 May 2014 17:29, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Wed, May 14, 2014 at 8:53 AM, Tushar Behera <tushar.behera@linaro.org> wrote:
>> While playing back audio, pmc_dmaengine requests the DMA channel to
>> stop DMA transmission through DMA_PAUSE command.
>>
>> Currently PL330 driver doesn't support DMA pause command, leaving
>> the DMA state inconsistent when the system resumes. Instead, it would
>> be better to terminate the DMA transfer during suspend and restart
>> again during resume.
>>
>> Tested with audio playback across a suspend-resume cycle.
>>
> What is pmc_dmaengine? How does DMA_PAUSE help, when there is no DMA_RESUME?
>

Sorry, it is a typo.

sound/core/pcm_dmaengine.c:snd_dmaengine_pcm_trigger() -->
dmaengine_pause() is called during system suspend.

> DMA_PAUSE means freezing the transfer, not dropping it. DMA_RESUME
> then moves the transfer again from that point. Clubbing PAUSE with
> TERMINATE is plain wrong.  Sorry.
>

Would you please suggest how should we go ahead with implementing
DMA_PAUSE/DMA_RESUME support for PL330 driver?

> Regards
> Jassi

Thanks,
-- 
Tushar Behera
