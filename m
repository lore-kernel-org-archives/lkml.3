Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbaDDP1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:27:51 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25211 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753629AbaDDP1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:27:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19toWYHynrlKW2nSv0929S9QyrGAE/u690=
X-DKIM: OpenDKIM Filter v2.0.1 titan 288FD551EFF
Date: Fri, 4 Apr 2014 11:27:46 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: fakeroot make-kpkg is broken in 3.14
Message-ID: <20140404152746.GC28334@titan.lakedaemon.net>
References: <CAMEtUuyLOFOfJDOjsx8+L35_ULnmY+oBCMc5nqerncXe=FGH_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuyLOFOfJDOjsx8+L35_ULnmY+oBCMc5nqerncXe=FGH_w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexei,

Thanks for the heads up.

On Thu, Apr 03, 2014 at 03:12:38PM -0700, Alexei Starovoitov wrote:
> It seems commit f4d4ffc03efc ("kbuild: dtbs_install: new make target")
> breaks 'fakeroot make-kpkg' package creation on ubuntu.
> Didn't investigate the root cause yet, just heads up.

Grant's version differs significantly from what I had proposed.  Which
isn't a big deal, except that I'm not familiar with why he added the
'prepare' target to dtbs dtbs_install.  It's also clear from the patch
that he is _much_ more familiar with the guts of the kernel Makefile
system than I am ;-)

> The errors I see:
> update-initramfs: Generating
> /w/net/debian/linux-image-3.14.0+//boot/initrd.img-3.14.0+
> grep: /boot/config-3.14.0+: No such file or directory
> WARNING: missing /lib/modules/3.14.0+
> Device driver support needs thus be built-in linux image!
> WARNING: Couldn't open directory /lib/modules/3.14.0+: No such file or directory
> FATAL: Could not open /lib/modules/3.14.0+/modules.dep.temp for
> writing: No such file or directory
> ERROR: ld.so: object 'libfakeroot-sysv.so' from LD_PRELOAD cannot be
> preloaded: ignored.
> ERROR: ld.so: object 'libfakeroot-sysv.so' from LD_PRELOAD cannot be
> preloaded: ignored.
> /dev/sda1: Permission denied
> FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
> or directory
> FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
> or directory
> FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
> or directory
> FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
> or directory
> FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
> or directory

This really doesn't tell us much as I'm not familiar with make-kpkg and
the assumptions it makes.  Please provide more details once you've
investigated a bit more.

On a side note: It's a bit concerning to see make-kpkg grepping the
config.  In general, one should directly test for features as config
symbols are not ABI and can change at any time.

thx,

Jason.
