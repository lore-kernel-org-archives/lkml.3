Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaDONkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:40:32 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:63133 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaDONka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:40:30 -0400
Date: Tue, 15 Apr 2014 09:43:40 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>
Subject: [bisected] broken make-kpkg kernel build in 3.15-rc1
Message-ID: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following commit breaks building the kernel using the debian
make-kpkg command

commit f4d4ffc03efc864645b990e1d579bbe1b8e358a4
Author: Jason Cooper <jason@lakedaemon.net>
Date:   Sun Dec 1 23:56:28 2013 +0000

    kbuild: dtbs_install: new make target


If I run this:
	make-kpkg --initrd --rootcmd fakeroot kernel_image

After this commit it fails with:

make[2]: Entering directory `/home/vince/research/linux-kernel/linux-git'
sh /home/vince/research/linux-kernel/linux-git/arch/x86/boot/install.sh 
3.14.0-rc6+ arch/x86/boot/bzImage \
		System.map 
"/home/vince/research/linux-kernel/linux-git/debian/linux-image-3.14.0-rc6+//boot"
run-parts: executing /etc/kernel/postinst.d/apt-auto-removal 3.14.0-rc6+ 
/home/vince/research/linux-kernel/linux-git/debian/linux-image-3.14.0-rc6+//boot/vmlinuz-3.14.0-rc6+
/etc/kernel/postinst.d/apt-auto-removal: 84: 
/etc/kernel/postinst.d/apt-auto-removal: cannot create 
/etc/apt/apt.conf.d//01autoremove-kernels.dpkg-new: Permission denied
run-parts: /etc/kernel/postinst.d/apt-auto-removal exited with return code 
2
make[3]: *** [install] Error 1
make[2]: *** [install] Error 2
make[2]: Leaving directory `/home/vince/research/linux-kernel/linux-git'
make[1]: *** [debian/stamp/install/linux-image-3.14.0-rc6+] Error 2
make[1]: Leaving directory `/home/vince/research/linux-kernel/linux-git'
make: *** [kernel_image] Error 2

Wasted a whole day tracking this down, thought it was a problem with a new 
version of apt.

Vince
