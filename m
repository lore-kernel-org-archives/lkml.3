Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaISE4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 00:56:52 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:41829 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaISE4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 00:56:51 -0400
Message-ID: <541BB786.1070700@roeck-us.net>
Date: Thu, 18 Sep 2014 21:56:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: Re: [PATCH] openrisc: Support both old (or32) and new (or1k) toolchain
References: <1410210049-30800-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1410210049-30800-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.541BB793.000E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping ... comments / feedback anyone ?

Guenter

On 09/08/2014 02:00 PM, Guenter Roeck wrote:
> The output file format for openrisc has changed from "elf32-or32"
> to "elf32-or1k" when using the or1k instead of the older or32 toochain.
> Select the correct output format automatically to be able to compile
> the kernel with both toolchain variants.
>
> Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Candidate for -stable ?
>
>   arch/openrisc/kernel/vmlinux.lds.S | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/openrisc/kernel/vmlinux.lds.S b/arch/openrisc/kernel/vmlinux.lds.S
> index 2d69a85..1c5d21a 100644
> --- a/arch/openrisc/kernel/vmlinux.lds.S
> +++ b/arch/openrisc/kernel/vmlinux.lds.S
> @@ -30,7 +30,13 @@
>   #include <asm/cache.h>
>   #include <asm-generic/vmlinux.lds.h>
>
> -OUTPUT_FORMAT("elf32-or32", "elf32-or32", "elf32-or32")
> +#ifdef __OR1K__
> +#define __OUTPUT_FORMAT	"elf32-or1k"
> +#else
> +#define __OUTPUT_FORMAT	"elf32-or32"
> +#endif
> +
> +OUTPUT_FORMAT(__OUTPUT_FORMAT, __OUTPUT_FORMAT, __OUTPUT_FORMAT)
>   jiffies = jiffies_64 + 4;
>
>   SECTIONS
>

