Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaA0W7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:59:00 -0500
Received: from mout.gmx.net ([212.227.15.18]:52179 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbaA0W66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:58:58 -0500
Message-ID: <52E6E4AE.4040906@gmx.de>
Date: Mon, 27 Jan 2014 23:58:54 +0100
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: gxt@mprc.pku.edu.cn, paul.gortmaker@windriver.com, vapier@gentoo.org,
        totglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] __init setup_early_printk: missing initialization
References: <1390846224-6995-1-git-send-email-xypron.glpk@gmx.de> <20140127134959.72c65d0091554e36d1755ab0@linux-foundation.org>
In-Reply-To: <20140127134959.72c65d0091554e36d1755ab0@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:zjVttGSUjxy/AFCz//sgVoRJxLhOYvlagop9Rn1G8N6Ko4lsDYZ
 RXTHfl/hnJAgrXUMIiJccIAC9gx3fNjohtErTzMLzH7qv4jQtsS9aSZHYjnqR+OZ6XyBqsy
 nm3T75yOYTJExPvMGgDMBBqIAcmZqOUerOBNSVEnhtzB5pOlRgkAyOSaHZABftVnd6EPGPh
 Blsihmoo4hTszAXzdsJdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.01.2014 22:49, Andrew Morton wrote:
> On Mon, 27 Jan 2014 19:10:24 +0100 xypron.glpk@gmx.de wrote:
>
>> From: Heinrich Schuchardt <xypron.glpk@gmx.de>
>>
>> If is based on uninitialized value keep_early.
>> This leads to unpredictable result.
>>
>> ...
>>
>> --- a/arch/unicore32/kernel/early_printk.c
>> +++ b/arch/unicore32/kernel/early_printk.c
>> @@ -35,7 +35,7 @@ static struct console early_ocd_console = {
>>
>>   static int __init setup_early_printk(char *buf)
>>   {
>> -	int keep_early;
>> +	int keep_early = 0;
>>
>>   	if (!buf || early_console)
>>   		return 0;
>
> yup.
>
> But that code is quite overcooked.  How about this?
>
> --- a/arch/unicore32/kernel/early_printk.c~arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix
> +++ a/arch/unicore32/kernel/early_printk.c
> @@ -35,17 +35,11 @@ static struct console early_ocd_console
>
>   static int __init setup_early_printk(char *buf)
>   {
> -	int keep_early = 0;
> -
>   	if (!buf || early_console)
>   		return 0;
>
> -	if (strstr(buf, "keep"))
> -		keep_early = 1;
> -
>   	early_console = &early_ocd_console;
> -
> -	if (keep_early)
> +	if (strstr(buf, "keep"))
>   		early_console->flags &= ~CON_BOOT;
>   	else
>   		early_console->flags |= CON_BOOT;
> _
>
>

Your code is easier to read, and has same functionality.
