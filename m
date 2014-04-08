Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaDHAxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 20:53:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41745 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaDHAxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 20:53:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140404152746.GC28334@titan.lakedaemon.net>
References: <CAMEtUuyLOFOfJDOjsx8+L35_ULnmY+oBCMc5nqerncXe=FGH_w@mail.gmail.com>
	<20140404152746.GC28334@titan.lakedaemon.net>
Date: Mon, 7 Apr 2014 17:53:29 -0700
Message-ID: <CAMEtUuwv_9PmmJrn_oaY031O+E4gNmOWQ0f_iwPJg0MxfjQ55Q@mail.gmail.com>
Subject: Re: fakeroot make-kpkg is broken in 3.14
From: Alexei Starovoitov <ast@plumgrid.com>
To: Jason Cooper <jason@lakedaemon.net>,
        Manoj Srivastava <srivasta@debian.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 8:27 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> Alexei,
>
> Thanks for the heads up.
>
> On Thu, Apr 03, 2014 at 03:12:38PM -0700, Alexei Starovoitov wrote:
>> It seems commit f4d4ffc03efc ("kbuild: dtbs_install: new make target")
>> breaks 'fakeroot make-kpkg' package creation on ubuntu.
>> Didn't investigate the root cause yet, just heads up.
>
> Grant's version differs significantly from what I had proposed.  Which
> isn't a big deal, except that I'm not familiar with why he added the
> 'prepare' target to dtbs dtbs_install.  It's also clear from the patch
> that he is _much_ more familiar with the guts of the kernel Makefile
> system than I am ;-)

looks like it's a problem of make-kpkg itself.
It's doing:
./kernel/ruleset/misc/version_vars.mk:
HAVE_INST_PATH  =$(call doit,grep -E '\(INSTALL_PATH\)' Makefile 2>/dev/null )
which is now being true and it triggers different path through package build.
Ccing Manoj who's the author of this stuff.

I think this issue will affect ubuntu guys.

>> The errors I see:
>> update-initramfs: Generating
>> /w/net/debian/linux-image-3.14.0+//boot/initrd.img-3.14.0+
>> grep: /boot/config-3.14.0+: No such file or directory
>> WARNING: missing /lib/modules/3.14.0+
>> Device driver support needs thus be built-in linux image!
>> WARNING: Couldn't open directory /lib/modules/3.14.0+: No such file or directory
>> FATAL: Could not open /lib/modules/3.14.0+/modules.dep.temp for
>> writing: No such file or directory
>> ERROR: ld.so: object 'libfakeroot-sysv.so' from LD_PRELOAD cannot be
>> preloaded: ignored.
>> ERROR: ld.so: object 'libfakeroot-sysv.so' from LD_PRELOAD cannot be
>> preloaded: ignored.
>> /dev/sda1: Permission denied
>> FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
>> or directory
>> FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
>> or directory
>> FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
>> or directory
>> FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
>> or directory
>> FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
>> or directory
>
> This really doesn't tell us much as I'm not familiar with make-kpkg and
> the assumptions it makes.  Please provide more details once you've
> investigated a bit more.
>
> On a side note: It's a bit concerning to see make-kpkg grepping the
> config.  In general, one should directly test for features as config
> symbols are not ABI and can change at any time.
>
> thx,
>
> Jason.
