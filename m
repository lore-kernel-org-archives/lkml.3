Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaIOLFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 07:05:42 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40580 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaIOLFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 07:05:39 -0400
Message-ID: <5416C941.9020503@gmail.com>
Date: Mon, 15 Sep 2014 19:10:57 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Michal Simek <monstr@monstr.eu>, Rob Herring <rob.herring@calxeda.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>
Subject: Re: [PATCH] arch/microblaze/kernel/setup.c: Add default 'screen_info"
 for fixing compiling break
References: <541552B8.8020807@gmail.com> <CAMuHMdU6adYoOafUZ2STZCeuQa3cU-_kD7FHW3x=Tq-O+aqrZw@mail.gmail.com> <20140915085029.GY4659@axis.com>
In-Reply-To: <20140915085029.GY4659@axis.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/14 16:50, Jesper Nilsson wrote:
> On Sun, Sep 14, 2014 at 10:45:23AM +0200, Geert Uytterhoeven wrote:
>> Hi Chen,
>>
>> On Sun, Sep 14, 2014 at 10:32 AM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>>> Add default one just like other architectures have done (e.g. cris,
>>> score, sh ...), the related error with allmodconfig:
>>>
>>>     LD      init/built-in.o
>>>   drivers/built-in.o: In function `vgacon_save_screen':
>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x834d0): undefined reference to `screen_info'
>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x834ec): undefined reference to `screen_info'
>>>   drivers/built-in.o: In function `vgacon_resize':
>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83cdc): undefined reference to `screen_info'
>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83d38): undefined reference to `screen_info'
>>>   drivers/built-in.o: In function `vgacon_switch':
>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83f50): undefined reference to `screen_info'
>>>   drivers/built-in.o:drivers/video/console/.tmp_vgacon.o:(.text+0x8407c): more undefined references to `screen_info' follow
>>>   make: *** [vmlinux] Error 1
>>
>> Can microblaze actually have VGA?
>>
>> If not, it's better to disable it.
>>
>> BTW, it's interesting you mention cris, as VGA_CONSOLE depends on !CRIS
>> in drivers/video/console/Kconfig...
> 
> No CRIS platform has ever had a video console.
> 
>> I (still) think it's time to introduce ARCH_MIGHT_HAVE_VGA, and make
>> VGA_CONSOLE depend on that, cfr.
> 
> Sounds reasonable, at least it can avoid the specific depends on !*arch* cruft.
> 

Thank you very much, next when I try the ARCH_MIGHT_HAVE_VGA, I shall
process it (remove useless "screen_info").


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
