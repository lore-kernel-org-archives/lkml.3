Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaINJCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:02:54 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53171 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbaINJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:02:53 -0400
Message-ID: <541559C2.8070703@gmail.com>
Date: Sun, 14 Sep 2014 17:02:58 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Michal Simek <monstr@monstr.eu>, Rob Herring <rob.herring@calxeda.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [PATCH] arch/microblaze/kernel/setup.c: Add default 'screen_info"
 for fixing compiling break
References: <541552B8.8020807@gmail.com> <CAMuHMdU6adYoOafUZ2STZCeuQa3cU-_kD7FHW3x=Tq-O+aqrZw@mail.gmail.com>
In-Reply-To: <CAMuHMdU6adYoOafUZ2STZCeuQa3cU-_kD7FHW3x=Tq-O+aqrZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2014 04:45 PM, Geert Uytterhoeven wrote:
> Hi Chen,
> 
> On Sun, Sep 14, 2014 at 10:32 AM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>> Add default one just like other architectures have done (e.g. cris,
>> score, sh ...), the related error with allmodconfig:
>>
>>     LD      init/built-in.o
>>   drivers/built-in.o: In function `vgacon_save_screen':
>>   drivers/video/console/.tmp_vgacon.o:(.text+0x834d0): undefined reference to `screen_info'
>>   drivers/video/console/.tmp_vgacon.o:(.text+0x834ec): undefined reference to `screen_info'
>>   drivers/built-in.o: In function `vgacon_resize':
>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83cdc): undefined reference to `screen_info'
>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83d38): undefined reference to `screen_info'
>>   drivers/built-in.o: In function `vgacon_switch':
>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83f50): undefined reference to `screen_info'
>>   drivers/built-in.o:drivers/video/console/.tmp_vgacon.o:(.text+0x8407c): more undefined references to `screen_info' follow
>>   make: *** [vmlinux] Error 1
> 
> Can microblaze actually have VGA?
> 
> If not, it's better to disable it.
> 

Welcome the related microblaze maintainers ideas for it

> BTW, it's interesting you mention cris, as VGA_CONSOLE depends on !CRIS
> in drivers/video/console/Kconfig...
> 

Welcome the related cris maintainers ideas for it.

> I (still) think it's time to introduce ARCH_MIGHT_HAVE_VGA, and make
> VGA_CONSOLE depend on that, cfr.
> 
> commit f13399f033ae3d49e1808bacabd83d116844c94e
> Merge: 049ffa8ab33a b2c32b32a212
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Nov 15 14:05:15 2013 -0800
> 
>     Merge tag 'for-linus' of
> git://linux-c6x.org/git/projects/linux-c6x-upstreaming
> 
>     Pull Kconfig cleanups from Mark Salter:
>      "Remove some unused config options from C6X and clean up PC_PARPORT
>       dependencies.  The latter was discussed here:
> 
>         https://lkml.org/lkml/2013/10/8/12"
> 
>     * tag 'for-linus' of git://linux-c6x.org/git/projects/linux-c6x-upstreaming:
>       c6x: remove unused COMMON_CLKDEV Kconfig parameter
>       Kconfig cleanup (PARPORT_PC dependencies)
>       x86: select ARCH_MIGHT_HAVE_PC_PARPORT
>       unicore32: select ARCH_MIGHT_HAVE_PC_PARPORT
>       sparc: select ARCH_MIGHT_HAVE_PC_PARPORT
>       sh: select ARCH_MIGHT_HAVE_PC_PARPORT
>       powerpc: select ARCH_MIGHT_HAVE_PC_PARPORT
>       parisc: select ARCH_MIGHT_HAVE_PC_PARPORT
>       mips: select ARCH_MIGHT_HAVE_PC_PARPORT
>       microblaze: select ARCH_MIGHT_HAVE_PC_PARPORT
>       m68k: select ARCH_MIGHT_HAVE_PC_PARPORT
>       ia64: select ARCH_MIGHT_HAVE_PC_PARPORT
>       arm: select ARCH_MIGHT_HAVE_PC_PARPORT
>       alpha: select ARCH_MIGHT_HAVE_PC_PARPORT
>       c6x: remove unused parameter in Kconfig
> 

At least for me, the contents above sounds reasonable.

And also thank you very much for always supporting me for sending
'global' patches for Kconfig.

But in honest, what I have done is not quite well, at present. And I
should continue trying...


Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
