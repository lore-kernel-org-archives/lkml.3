Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaEVAcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:32:05 -0400
Received: from mx10.pku.edu.cn ([162.105.129.173]:39912 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750982AbaEVAcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:32:03 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.487
Date: Thu, 22 May 2014 08:31:52 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <750179772.46188.1400718712110.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <537D4296.7060402@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re?=
 =?utf-8?Q?:_=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_=E5=9B=9E=E5=A4=8D=EF=BC=9A_[?=
 =?utf-8?Q?PATCH]_arch/unicore32/kernel/s?=
 =?utf-8?Q?etup.c:_add_generic_'screen=5Finfo'_to_avoid_compiling_failure?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> On 05/22/2014 07:59 AM, 管雪涛 wrote:
> > ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> >>>>  - the other for additional 'clk_*' which are needed when HAVE_CLK.
> >>>>    I guess, just "copy/past" the other platforms' implementation is OK.
> >>>
> >>> Maybe, COMMON_CLK should be selected. I'm not sure.
> >>>
> >>
> >> I guess so, if you have already fix it (maybe you have done, I am not
> >> quite familiar with version merging of Linux kernel), please let me
> >> know. Or I shall process (continue think of) it within this month.
> > 
> > Ok, I'll arrange this work, but maybe finish it in next month.
> >
> 
> Thanks, it is OK to me.
> 
> And for this last issue of unicore32 allmodconfig, it needs COMMON_CLK,
> but after add it, it will generate a conflict between "arch/unicore32
> /kernel/clock.c" and "drivers/clk/clk.c".

Yes, they implement similar functions, and I need use the latter to reimplement the former.

> 
> I guess it needs more thinking of about architecture related features,
> I am not quite sure about it, so please help fix it, when you have
> time, thanks.
> 
> The related error:
> 
>     LD      vmlinux.o
>   drivers/built-in.o: In function `clk_unregister':
>   powercap_sys.c:(.text+0xa96d0): multiple definition of `clk_unregister'
>   arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3874): first defined here
>   drivers/built-in.o: In function `clk_get':
>   powercap_sys.c:(.text+0xa7040): multiple definition of `clk_get'
>   arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3b7c): first defined here
>   drivers/built-in.o:(___ksymtab_gpl+clk_enable+0x0): multiple definition of `__ksymtab_clk_enable'
>   arch/unicore32/kernel/built-in.o:(___ksymtab+clk_enable+0x0): first defined here
>   drivers/built-in.o: In function `clk_enable':
>   powercap_sys.c:(.text+0xa8218): multiple definition of `clk_enable'
>   arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3834): first defined here
>   drivers/built-in.o: In function `__crc_clk_enable':
>   powercap_sys.c:(*ABS*+0xeadcf0e8): multiple definition of `__crc_clk_enable'
>   drivers/built-in.o: In function `clk_set_rate':
>   powercap_sys.c:(.text+0xa99f4): multiple definition of `clk_set_rate'
>   arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3950): first defined here
>   drivers/built-in.o: In function `__crc_clk_get_rate':
>   powercap_sys.c:(*ABS*+0x8f47d06d): multiple definition of `__crc_clk_get_rate'
>   drivers/built-in.o:(___ksymtab+clk_put+0x0): multiple definition of `__ksymtab_clk_put'
>   arch/unicore32/kernel/built-in.o:(___ksymtab+clk_put+0x0): first defined here
>   drivers/built-in.o: In function `__crc_clk_get':
>   powercap_sys.c:(*ABS*+0x7bf53891): multiple definition of `__crc_clk_get'
>   drivers/built-in.o:(___ksymtab_gpl+clk_unregister+0x0): multiple definition of `__ksymtab_clk_unregister'
>   arch/unicore32/kernel/built-in.o:(___ksymtab+clk_unregister+0x0): first defined here
>   drivers/built-in.o:(___ksymtab+clk_get+0x0): multiple definition of `__ksymtab_clk_get'
>   arch/unicore32/kernel/built-in.o:(___ksymtab+clk_get+0x0): first defined here
>   drivers/built-in.o: In function `__crc_clk_disable':
>   powercap_sys.c:(*ABS*+0xaf08af3a): multiple definition of `__crc_clk_disable'
>   drivers/built-in.o: In function `__crc_clk_register':
>   powercap_sys.c:(*ABS*+0x9524c67b): multiple definition of `__crc_clk_register'
>   drivers/built-in.o: In function `clk_put':
>   powercap_sys.c:(.text+0xa6e08): multiple definition of `clk_put'
>   arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3820): first defined here
>   drivers/built-in.o:(___ksymtab_gpl+clk_disable+0x0): multiple definition of `__ksymtab_clk_disable'
>   arch/unicore32/kernel/built-in.o:(___ksymtab+clk_disable+0x0): first defined here
>   drivers/built-in.o: In function `clk_disable':
>   powercap_sys.c:(.text+0xa82b4): multiple definition of `clk_disable' 
>   arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x3848): first defined here
>   drivers/built-in.o:(___ksymtab_gpl+clk_set_rate+0x0): multiple definition of `__ksymtab_clk_set_rate'
>   arch/unicore32/kernel/built-in.o:(___ksymtab+clk_set_rate+0x0): first defined here
>   drivers/built-in.o: In function `clk_register':
>   powercap_sys.c:(.text+0xa9fc0): multiple definition of `clk_register'
>   arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x38ac): first defined here
>   drivers/built-in.o:(___ksymtab_gpl+clk_get_rate+0x0): multiple definition of `__ksymtab_clk_get_rate'
>   arch/unicore32/kernel/built-in.o:(___ksymtab+clk_get_rate+0x0): first defined here
>   drivers/built-in.o: In function `__crc_clk_unregister':
>   powercap_sys.c:(*ABS*+0x75abf69c): multiple definition of `__crc_clk_unregister'
>   drivers/built-in.o: In function `clk_get_rate':
>   powercap_sys.c:(.text+0xa8efc): multiple definition of `clk_get_rate'
>   arch/unicore32/kernel/built-in.o:puv3-core.c:(.text+0x385c): first defined here
>   drivers/built-in.o:(___ksymtab_gpl+clk_register+0x0): multiple definition of `__ksymtab_clk_register'
>   arch/unicore32/kernel/built-in.o:(___ksymtab+clk_register+0x0): first defined here
>   drivers/built-in.o: In function `__crc_clk_set_rate':
>   powercap_sys.c:(*ABS*+0x1cdb742b): multiple definition of `__crc_clk_set_rate'
>   make: *** [vmlinux] Error 1
> 
> 
> Thanks.
> -- 
> Chen Gang
> 
> Open, share, and attitude like air, water, and life which God blessed

