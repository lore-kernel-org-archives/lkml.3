Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaIOI4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:56:39 -0400
Received: from bes.se.axis.com ([195.60.68.10]:37846 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbaIOI4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:56:38 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 04:56:38 EDT
Date: Mon, 15 Sep 2014 10:50:29 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, Michal Simek <monstr@monstr.eu>,
        Rob Herring <rob.herring@calxeda.com>, Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>
Subject: Re: [PATCH] arch/microblaze/kernel/setup.c: Add default
 'screen_info" for fixing compiling break
Message-ID: <20140915085029.GY4659@axis.com>
References: <541552B8.8020807@gmail.com>
 <CAMuHMdU6adYoOafUZ2STZCeuQa3cU-_kD7FHW3x=Tq-O+aqrZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdU6adYoOafUZ2STZCeuQa3cU-_kD7FHW3x=Tq-O+aqrZw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 10:45:23AM +0200, Geert Uytterhoeven wrote:
> Hi Chen,
> 
> On Sun, Sep 14, 2014 at 10:32 AM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
> > Add default one just like other architectures have done (e.g. cris,
> > score, sh ...), the related error with allmodconfig:
> >
> >     LD      init/built-in.o
> >   drivers/built-in.o: In function `vgacon_save_screen':
> >   drivers/video/console/.tmp_vgacon.o:(.text+0x834d0): undefined reference to `screen_info'
> >   drivers/video/console/.tmp_vgacon.o:(.text+0x834ec): undefined reference to `screen_info'
> >   drivers/built-in.o: In function `vgacon_resize':
> >   drivers/video/console/.tmp_vgacon.o:(.text+0x83cdc): undefined reference to `screen_info'
> >   drivers/video/console/.tmp_vgacon.o:(.text+0x83d38): undefined reference to `screen_info'
> >   drivers/built-in.o: In function `vgacon_switch':
> >   drivers/video/console/.tmp_vgacon.o:(.text+0x83f50): undefined reference to `screen_info'
> >   drivers/built-in.o:drivers/video/console/.tmp_vgacon.o:(.text+0x8407c): more undefined references to `screen_info' follow
> >   make: *** [vmlinux] Error 1
> 
> Can microblaze actually have VGA?
> 
> If not, it's better to disable it.
> 
> BTW, it's interesting you mention cris, as VGA_CONSOLE depends on !CRIS
> in drivers/video/console/Kconfig...

No CRIS platform has ever had a video console.

> I (still) think it's time to introduce ARCH_MIGHT_HAVE_VGA, and make
> VGA_CONSOLE depend on that, cfr.

Sounds reasonable, at least it can avoid the specific depends on !*arch* cruft.

> Gr{oetje,eeting}s,
> 
>                         Geert

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
