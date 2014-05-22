Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaEVATl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:19:41 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:49287 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaEVATj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:19:39 -0400
Message-ID: <537D4296.7060402@gmail.com>
Date: Thu, 22 May 2014 08:19:34 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFJlOiDlm57lpI3vvJogUmU6IOWbnuWkje+8miA=?=
 =?UTF-8?B?W1BBVENIXSBhcmNoL3VuaWNvcmUzMi9rZXJuZWwvc2V0dXAuYzogYWRkIGdlbmU=?=
 =?UTF-8?B?cmljICdzY3JlZW5faW5mbycgdG8gYXZvaWQgY29tcGlsaW5nIGZhaWx1cmU=?=
References: <256522481.45786.1400716795052.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <256522481.45786.1400716795052.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 07:59 AM, 管雪涛 wrote:
> ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
>>>>  - the other for additional 'clk_*' which are needed when HAVE_CLK.
>>>>    I guess, just "copy/past" the other platforms' implementation is OK.
>>>
>>> Maybe, COMMON_CLK should be selected. I'm not sure.
>>>
>>
>> I guess so, if you have already fix it (maybe you have done, I am not
>> quite familiar with version merging of Linux kernel), please let me
>> know. Or I shall process (continue think of) it within this month.
> 
> Ok, I'll arrange this work, but maybe finish it in next month.
>

Thanks, it is OK to me.

And for this last issue of unicore32 allmodconfig, it needs COMMON_CLK,
but after add it, it will generate a conflict between "arch/unicore32
/kernel/clock.c" and "drivers/clk/clk.c".

I guess it needs more thinking of about architecture related features,
I am not quite sure about it, so please help fix it, when you have
time, thanks.

The related error:

    LD      vmlinux.o
  drivers/built-in.o: In function `clk_unregister':
  powercap_sys.c:(.text+0xa96d0): multiple definition of `clk_unregister'
  arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3874): first defined here
  drivers/built-in.o: In function `clk_get':
  powercap_sys.c:(.text+0xa7040): multiple definition of `clk_get'
  arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3b7c): first defined here
  drivers/built-in.o:(___ksymtab_gpl+clk_enable+0x0): multiple definition of `__ksymtab_clk_enable'
  arch/unicore32/kernel/built-in.o:(___ksymtab+clk_enable+0x0): first defined here
  drivers/built-in.o: In function `clk_enable':
  powercap_sys.c:(.text+0xa8218): multiple definition of `clk_enable'
  arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3834): first defined here
  drivers/built-in.o: In function `__crc_clk_enable':
  powercap_sys.c:(*ABS*+0xeadcf0e8): multiple definition of `__crc_clk_enable'
  drivers/built-in.o: In function `clk_set_rate':
  powercap_sys.c:(.text+0xa99f4): multiple definition of `clk_set_rate'
  arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3950): first defined here
  drivers/built-in.o: In function `__crc_clk_get_rate':
  powercap_sys.c:(*ABS*+0x8f47d06d): multiple definition of `__crc_clk_get_rate'
  drivers/built-in.o:(___ksymtab+clk_put+0x0): multiple definition of `__ksymtab_clk_put'
  arch/unicore32/kernel/built-in.o:(___ksymtab+clk_put+0x0): first defined here
  drivers/built-in.o: In function `__crc_clk_get':
  powercap_sys.c:(*ABS*+0x7bf53891): multiple definition of `__crc_clk_get'
  drivers/built-in.o:(___ksymtab_gpl+clk_unregister+0x0): multiple definition of `__ksymtab_clk_unregister'
  arch/unicore32/kernel/built-in.o:(___ksymtab+clk_unregister+0x0): first defined here
  drivers/built-in.o:(___ksymtab+clk_get+0x0): multiple definition of `__ksymtab_clk_get'
  arch/unicore32/kernel/built-in.o:(___ksymtab+clk_get+0x0): first defined here
  drivers/built-in.o: In function `__crc_clk_disable':
  powercap_sys.c:(*ABS*+0xaf08af3a): multiple definition of `__crc_clk_disable'
  drivers/built-in.o: In function `__crc_clk_register':
  powercap_sys.c:(*ABS*+0x9524c67b): multiple definition of `__crc_clk_register'
  drivers/built-in.o: In function `clk_put':
  powercap_sys.c:(.text+0xa6e08): multiple definition of `clk_put'
  arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3820): first defined here
  drivers/built-in.o:(___ksymtab_gpl+clk_disable+0x0): multiple definition of `__ksymtab_clk_disable'
  arch/unicore32/kernel/built-in.o:(___ksymtab+clk_disable+0x0): first defined here
  drivers/built-in.o: In function `clk_disable':
  powercap_sys.c:(.text+0xa82b4): multiple definition of `clk_disable' 
  arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3848): first defined here
  drivers/built-in.o:(___ksymtab_gpl+clk_set_rate+0x0): multiple definition of `__ksymtab_clk_set_rate'
  arch/unicore32/kernel/built-in.o:(___ksymtab+clk_set_rate+0x0): first defined here
  drivers/built-in.o: In function `clk_register':
  powercap_sys.c:(.text+0xa9fc0): multiple definition of `clk_register'
  arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x38ac): first defined here
  drivers/built-in.o:(___ksymtab_gpl+clk_get_rate+0x0): multiple definition of `__ksymtab_clk_get_rate'
  arch/unicore32/kernel/built-in.o:(___ksymtab+clk_get_rate+0x0): first defined here
  drivers/built-in.o: In function `__crc_clk_unregister':
  powercap_sys.c:(*ABS*+0x75abf69c): multiple definition of `__crc_clk_unregister'
  drivers/built-in.o: In function `clk_get_rate':
  powercap_sys.c:(.text+0xa8efc): multiple definition of `clk_get_rate'
  arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x385c): first defined here
  drivers/built-in.o:(___ksymtab_gpl+clk_register+0x0): multiple definition of `__ksymtab_clk_register'
  arch/unicore32/kernel/built-in.o:(___ksymtab+clk_register+0x0): first defined here
  drivers/built-in.o: In function `__crc_clk_set_rate':
  powercap_sys.c:(*ABS*+0x1cdb742b): multiple definition of `__crc_clk_set_rate'
  make: *** [vmlinux] Error 1


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
