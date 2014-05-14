Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaENL7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:59:09 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:54098 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbaENL7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:59:07 -0400
MIME-Version: 1.0
In-Reply-To: <1400037830-21211-1-git-send-email-tushar.behera@linaro.org>
References: <1400037830-21211-1-git-send-email-tushar.behera@linaro.org>
Date: Wed, 14 May 2014 17:29:05 +0530
Message-ID: <CABb+yY3YocX=8Dv7DysM4tcx=NTCCGGipz_gpMfpKDnAw7R8iw@mail.gmail.com>
Subject: Re: [PATCH] dma: pl330: Add support for DMA_PAUSE command
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 8:53 AM, Tushar Behera <tushar.behera@linaro.org> wrote:
> While playing back audio, pmc_dmaengine requests the DMA channel to
> stop DMA transmission through DMA_PAUSE command.
>
> Currently PL330 driver doesn't support DMA pause command, leaving
> the DMA state inconsistent when the system resumes. Instead, it would
> be better to terminate the DMA transfer during suspend and restart
> again during resume.
>
> Tested with audio playback across a suspend-resume cycle.
>
What is pmc_dmaengine? How does DMA_PAUSE help, when there is no DMA_RESUME?

DMA_PAUSE means freezing the transfer, not dropping it. DMA_RESUME
then moves the transfer again from that point. Clubbing PAUSE with
TERMINATE is plain wrong.  Sorry.

Regards
Jassi
