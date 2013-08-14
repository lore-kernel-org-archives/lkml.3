Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022Ab3HNQGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:06:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46753 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759953Ab3HNQG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:06:29 -0400
Message-ID: <520BAAEF.80100@codeaurora.org>
Date: Wed, 14 Aug 2013 11:06:07 -0500
From: Richard Kuo <rkuo@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: linux-kernel@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        linux-hexagon@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] hexagon: fix return type of ffs()
References: <1375882959-26853-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1375882959-26853-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 08:42 AM, Akinobu Mita wrote:
> The return type of ffs() is 'int' on all architectures except cris and
> hexagon.  This unifies the return type to 'int'.
>
> The problem I'm seeing is that the following line generates a warning
> on cris and hexagon because of the mismatch between format '%u' and
> return type of ffs().
>
> 	printk("bits in OOB size: %u\n",	ffs(ns->geom.oobsz) - 1);
>
> But removing this warning by casting to 'int' looks odd, so I suggest
> unifying the return type of ffs() on all architectures.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: linux-cris-kernel@axis.com
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: linux-hexagon@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> ---
> This patch is not compile tested yet, because I couldn't find cross
> compiler for hexagon.
>
>   arch/hexagon/include/asm/bitops.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/hexagon/include/asm/bitops.h b/arch/hexagon/include/asm/bitops.h
> index 9b1e4af..80e34a6 100644
> --- a/arch/hexagon/include/asm/bitops.h
> +++ b/arch/hexagon/include/asm/bitops.h
> @@ -234,7 +234,7 @@ static inline long fls(int x)
>    * the libc and compiler builtin ffs routines, therefore
>    * differs in spirit from the above ffz (man ffs).
>    */
> -static inline long ffs(int x)
> +static inline int ffs(int x)
>   {
>   	int r;
>   

For Hexagon:

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

