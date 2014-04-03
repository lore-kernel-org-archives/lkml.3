Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaDCWMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:12:42 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:49901 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaDCWMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:12:39 -0400
MIME-Version: 1.0
Date: Thu, 3 Apr 2014 15:12:38 -0700
Message-ID: <CAMEtUuyLOFOfJDOjsx8+L35_ULnmY+oBCMc5nqerncXe=FGH_w@mail.gmail.com>
Subject: fakeroot make-kpkg is broken in 3.14
From: Alexei Starovoitov <ast@plumgrid.com>
To: LKML <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems commit f4d4ffc03efc ("kbuild: dtbs_install: new make target")
breaks 'fakeroot make-kpkg' package creation on ubuntu.
Didn't investigate the root cause yet, just heads up.

The errors I see:
update-initramfs: Generating
/w/net/debian/linux-image-3.14.0+//boot/initrd.img-3.14.0+
grep: /boot/config-3.14.0+: No such file or directory
WARNING: missing /lib/modules/3.14.0+
Device driver support needs thus be built-in linux image!
WARNING: Couldn't open directory /lib/modules/3.14.0+: No such file or directory
FATAL: Could not open /lib/modules/3.14.0+/modules.dep.temp for
writing: No such file or directory
ERROR: ld.so: object 'libfakeroot-sysv.so' from LD_PRELOAD cannot be
preloaded: ignored.
ERROR: ld.so: object 'libfakeroot-sysv.so' from LD_PRELOAD cannot be
preloaded: ignored.
/dev/sda1: Permission denied
FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
or directory
FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
or directory
FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
or directory
FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
or directory
FATAL: Could not load /lib/modules/3.14.0+/modules.dep: No such file
or directory
