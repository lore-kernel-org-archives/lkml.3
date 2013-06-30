Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab3F3WWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 18:22:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59457 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751394Ab3F3WW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 18:22:29 -0400
Message-ID: <1372630948.2083.3.camel@joe-AO722>
Subject: Re: [PATCH] m68k/setup: Use pr_*() instead of plain printk()
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 30 Jun 2013 15:22:28 -0700
In-Reply-To: <1372585689-29492-1-git-send-email-geert@linux-m68k.org>
References: <1372585689-29492-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-30 at 11:48 +0200, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Hi Geert, just trivial comments...

> diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c

> @@ -161,7 +161,7 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
[]
> -				printk("m68k_parse_bootinfo: too many memory chunks\n");
> +				pr_warn("m68k_parse_bootinfo: too many memory chunks\n");

These are generally better written by
removing the hand-written function name
and using "%s: ", __func__

				pr_warn("%s: too many memory chunks\n",
					__func__);

> @@ -197,8 +197,8 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)

> -			printk("m68k_parse_bootinfo: unknown tag 0x%04x ignored\n",
> -			       record->tag);
> +			pr_warn("m68k_parse_bootinfo: unknown tag 0x%04x ignored\n",
> +				   record->tag);

etc.

> @@ -538,9 +538,9 @@ void check_bugs(void)
>  {
>  #ifndef CONFIG_M68KFPU_EMU
>  	if (m68k_fputype == 0) {
> -		printk(KERN_EMERG "*** YOU DO NOT HAVE A FLOATING POINT UNIT, "
> +		pr_emerg("*** YOU DO NOT HAVE A FLOATING POINT UNIT, "
>  			"WHICH IS REQUIRED BY LINUX/M68K ***\n");
> -		printk(KERN_EMERG "Upgrade your hardware or join the FPU "
> +		pr_emerg("Upgrade your hardware or join the FPU "
>  			"emulation project\n");

It would be nicer to coalesce the formats
into a single line.

