Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaIPKFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:05:18 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:49973 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaIPKE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <5418019E.1010202@monstr.eu>
References: <541552B8.8020807@gmail.com>
	<CAMuHMdU6adYoOafUZ2STZCeuQa3cU-_kD7FHW3x=Tq-O+aqrZw@mail.gmail.com>
	<541559C2.8070703@gmail.com>
	<5418019E.1010202@monstr.eu>
Date: Tue, 16 Sep 2014 12:04:57 +0200
X-Google-Sender-Auth: HgmRmz9WPqcPLGEeFHnzfDycbTI
Message-ID: <CAMuHMdWnZVi9rXzmOxsuwMeUcCvW_CH0bi_KuYiCNcp3JQHhLA@mail.gmail.com>
Subject: Re: [PATCH] arch/microblaze/kernel/setup.c: Add default 'screen_info"
 for fixing compiling break
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Tue, Sep 16, 2014 at 11:23 AM, Michal Simek <monstr@monstr.eu> wrote:
> On 09/14/2014 11:02 AM, Chen Gang wrote:
>> On 09/14/2014 04:45 PM, Geert Uytterhoeven wrote:
>>> Hi Chen,
>>>
>>> On Sun, Sep 14, 2014 at 10:32 AM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>>>> Add default one just like other architectures have done (e.g. cris,
>>>> score, sh ...), the related error with allmodconfig:
>>>>
>>>>     LD      init/built-in.o
>>>>   drivers/built-in.o: In function `vgacon_save_screen':
>>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x834d0): undefined reference to `screen_info'
>>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x834ec): undefined reference to `screen_info'
>>>>   drivers/built-in.o: In function `vgacon_resize':
>>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83cdc): undefined reference to `screen_info'
>>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83d38): undefined reference to `screen_info'
>>>>   drivers/built-in.o: In function `vgacon_switch':
>>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83f50): undefined reference to `screen_info'
>>>>   drivers/built-in.o:drivers/video/console/.tmp_vgacon.o:(.text+0x8407c): more undefined references to `screen_info' follow
>>>>   make: *** [vmlinux] Error 1
>>>
>>> Can microblaze actually have VGA?
>>>
>>> If not, it's better to disable it.
>>>
>>
>> Welcome the related microblaze maintainers ideas for it
>
> Is this is just about VGA or video console in general?
> There is xilinx FB driver and other FB are around too.

These days screen_info is only used by:
  - vgacon,
  - dummycon on ARM,
  - a few fb drivers (efifb, intelfbdrv,sis, vesafb, and vga16fb).

E.g. m68k doesn't have it.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
