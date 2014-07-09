Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbaGISPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:15:13 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:43693 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaGISPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:15:11 -0400
Message-ID: <53BD86B1.7050003@linaro.org>
Date: Wed, 09 Jul 2014 13:15:13 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        bp@suse.de, Jan Kara <jack@suse.cz>,
        John Stultz <john.stultz@linaro.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] printk: use a clever macro
References: <1404911056-29064-1-git-send-email-elder@linaro.org>	<1404911056-29064-4-git-send-email-elder@linaro.org> <CAMuHMdV9=0ZUYvvK5eZsN-fFuCHNKTW6Ab2rKvS5XsfVOhBh6Q@mail.gmail.com>
In-Reply-To: <CAMuHMdV9=0ZUYvvK5eZsN-fFuCHNKTW6Ab2rKvS5XsfVOhBh6Q@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 12:58 PM, Geert Uytterhoeven wrote:
> Hi Alex,
> 
> On Wed, Jul 9, 2014 at 3:04 PM, Alex Elder <elder@linaro.org> wrote:
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -453,11 +453,7 @@ static int log_store(int facility, int level,
>>         return msg->text_len;
>>  }
>>
>> -#ifdef CONFIG_SECURITY_DMESG_RESTRICT
>> -int dmesg_restrict = 1;
>> -#else
>> -int dmesg_restrict;
>> -#endif
>> +int dmesg_restrict = IS_ENABLED(CONFIG_SECURITY_DMESG_RESTRICT);
> 
> Doesn't this move dmesg_restrict from the bss to the data section
> in case CONFIG_SECURITY_DMESG_RESTRICT is not enabled, due
> to the explicit initialization to zero?

I honestly don't know.  Is that even a well-defined behavior?
Couldn't the compiler, noting an explicit 0 initialization,
put it into BSS anyway?

In any case, does this distinction matter?

					-Alex

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

