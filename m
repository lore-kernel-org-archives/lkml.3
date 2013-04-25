Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829Ab3DYVz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:55:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60663 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759802Ab3DYVz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:55:27 -0400
Message-ID: <5179A625.1080502@zytor.com>
Date: Thu, 25 Apr 2013 14:54:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] extable: Flip the sorting message
References: <1366023109-12098-1-git-send-email-bp@alien8.de>
In-Reply-To: <1366023109-12098-1-git-send-email-bp@alien8.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 03:51 AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Now that we do sort the __extable at build time, we actually are
> interested only in the case where we still do need to sort it.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: David Daney <david.daney@cavium.com>
> ---
>  kernel/extable.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/extable.c b/kernel/extable.c
> index fe35a634bf76..67460b93b1a1 100644
> --- a/kernel/extable.c
> +++ b/kernel/extable.c
> @@ -41,10 +41,10 @@ u32 __initdata main_extable_sort_needed = 1;
>  /* Sort the kernel's built-in exception table */
>  void __init sort_main_extable(void)
>  {
> -	if (main_extable_sort_needed)
> +	if (main_extable_sort_needed) {
> +		pr_notice("Sorting __ex_table...\n");
>  		sort_extable(__start___ex_table, __stop___ex_table);
> -	else
> -		pr_notice("__ex_table already sorted, skipping sort\n");
> +	}
>  }
>  

On some architectures we sort at runtime, on others we sort at build time.

Is there any reason for a message at all here?

	-hpa


