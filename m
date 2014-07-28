Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaG1GNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:13:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57052 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaG1GNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:13:33 -0400
Message-ID: <53D5E9F8.4030401@ti.com>
Date: Mon, 28 Jul 2014 09:13:12 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <nsekhar@ti.com>, <joelf@ti.com>, <vinod.koul@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <dmaengine@vger.kernel.org>, <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] dma: edma: Allow to disable eDMA IRQ during cyclic
 transfer
References: <1405513761-23739-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1405513761-23739-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 03:29 PM, Peter Ujfalusi wrote:
> Hi,
> 
> After this series clients can ask to not receive notifications after each period.
> In this case we can disable the completion interrupt since the position reporting
> does not rely on it for cyclic mode.
> Patchset for ASoC part has been sent which allows users space to take adventage
> of SNDRV_PCM_INFO_NO_PERIOD_WAKEUP:
> [1] http://mailman.alsa-project.org/pipermail/alsa-devel/2014-July/078993.html

ping.

> When both series applied on top of linux-next:
> 
> # cache the audio file in memory
> cat some_music.mp3 > /dev/null
> # start PA
> pulseaudio -v
> # in another terminal, play the music via PA
> mplayer -ao pulse some_music.mp3
> # yet another terminal to monitor the interrupts
> watch cat /proc/interrupts
> # note the non increasing number of edma interrupts ;)
> 
> Regards,
> Peter
> ---
> Peter Ujfalusi (2):
>   dma: edma: Update caps->residue_granularity to match with reality
>   dma: edma: Support to suppress the period interrupts in cyclic mode
> 
>  drivers/dma/edma.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 


-- 
Péter
