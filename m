Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab3EGMMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:12:41 -0400
Received: from ozlabs.org ([203.10.76.45]:46009 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433Ab3EGMMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:12:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, mst@redhat.com
Cc: Sam Ravnborg <sam@uranus.ravnborg.org>
Subject: Re: Add missing module license tag to vring helpers.
In-Reply-To: <20130506134123.GA8092@redhat.com>
References: <20130503204009.GA29376@redhat.com> <87bo8opnk8.fsf@rustcorp.com.au> <20130506134123.GA8092@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 07 May 2013 21:29:35 +0930
Message-ID: <87li7rngpk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:
> On Mon, May 06, 2013 at 05:06:23PM +0930, Rusty Russell wrote:
>  > Dave Jones <davej@redhat.com> writes:
>  > > [  624.286653] vringh: module license 'unspecified' taints kernel.
>  > >
>  > > Signed-off-by: Dave Jones <davej@redhat.com>
>  > 
>  > Thanks!  This is exactly right.
>  > 
>  > But note that the default license tag for otherwise-unlabelled modules
>  > would be "GPLv2".  "GPL" means v2 or later (which is what I want, but
>  > it's not the kernel default).
>
> It would be good if we could somehow catch missing tags at build-time
> rather than have to run around fixing them after they get merged.

Hmm, modpost seems to have code to detect that... but it doesn't.
That's because there's not .modinfo section at all, so for some reason
it doesn't warn.

Sam put this check in a few years ago, with a fairly useless commit
message:

commit 2fa365682943866baf85305ef701741fe41b27e0
Author: Sam Ravnborg <sam@uranus.ravnborg.org>
Date:   Sat Apr 26 21:07:26 2008 +0200

    kbuild: soften MODULE_LICENSE check
    
    Only modules that has other MODULE_* content
    shall have the MODULE_LICENSE() tag.
    
    This fixes allmodconfig build on my box.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Ripped that out, and fast forward a few hours later when I've done an
allmodconfig build; OK, now I'm confused.  Why do we hand
init/built-in.o to modpost?

        WARNING: modpost: missing MODULE_LICENSE() in init/built-in.o

There were some real problems found, too:

WARNING: modpost: missing MODULE_LICENSE() in drivers/acpi/acpi_i2c.o
see include/linux/module.h for more information
WARNING: modpost: missing MODULE_LICENSE() in drivers/mfd/cros_ec.o
see include/linux/module.h for more information
WARNING: modpost: missing MODULE_LICENSE() in drivers/mtd/nand/denali_pci.o
see include/linux/module.h for more information
WARNING: modpost: missing MODULE_LICENSE() in drivers/thermal/cpu_cooling.o
see include/linux/module.h for more information
WARNING: modpost: missing MODULE_LICENSE() in drivers/usb/phy/phy-samsung-usb.o
see include/linux/module.h for more information
WARNING: modpost: missing MODULE_LICENSE() in drivers/vhost/vringh.o
see include/linux/module.h for more information
WARNING: modpost: missing MODULE_LICENSE() in sound/soc/atmel/snd-soc-atmel-pcm.o
see include/linux/module.h for more information
WARNING: modpost: missing MODULE_LICENSE() in sound/soc/codecs/snd-soc-wm-adsp.o
see include/linux/module.h for more information

Confused,
Rusty.
