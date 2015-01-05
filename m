Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbbAEAik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 19:38:40 -0500
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.218]:14539
	"EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963AbbAEAij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 19:38:39 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2015 19:38:38 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEBAHHZqVSVhxBY/2dsb2JhbAANT4Qws1cBAQEBAQEGmCsCgRoBAQEBAYUKAQEEJ1EBEAsNCwkWDwkDAgECAUUGAQwBBQIBAa9ClC0BAQEBAQEBAQEBAQEBAQEBAQEBGYYDiXQHhCkBBIUnl3uLNoQiXYJDAQEB
X-IronPort-AV: E=Sophos;i="5.07,696,1413216000"; 
   d="scan'208";a="289916221"
Message-ID: <54A9DAEF.1020008@uclinux.org>
Date: Mon, 05 Jan 2015 10:29:35 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: m68k: 68360: config:  Remove unused function
References: <1420232714-3989-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1420232714-3989-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

On 03/01/15 07:05, Rickard Strandqvist wrote:
> Remove the function BSP_set_clock_mmss() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Thanks, I'll add it to the m68knommu git tree.

Regards
Greg


> ---
>  arch/m68k/68360/config.c |   13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/arch/m68k/68360/config.c b/arch/m68k/68360/config.c
> index 17ec416..fd1f948 100644
> --- a/arch/m68k/68360/config.c
> +++ b/arch/m68k/68360/config.c
> @@ -106,19 +106,6 @@ void hw_timer_init(irq_handler_t handler)
>    pquicc->timer_tgcr  = tgcr_save;
>  }
>  
> -int BSP_set_clock_mmss(unsigned long nowtime)
> -{
> -#if 0
> -  short real_seconds = nowtime % 60, real_minutes = (nowtime / 60) % 60;
> -
> -  tod->second1 = real_seconds / 10;
> -  tod->second2 = real_seconds % 10;
> -  tod->minute1 = real_minutes / 10;
> -  tod->minute2 = real_minutes % 10;
> -#endif
> -  return 0;
> -}
> -
>  void BSP_reset (void)
>  {
>    local_irq_disable();
> 

