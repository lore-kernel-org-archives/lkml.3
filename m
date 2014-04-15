Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaDOPD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:03:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaDOPDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:03:55 -0400
Message-ID: <534D4A59.6080401@suse.cz>
Date: Tue, 15 Apr 2014 17:03:53 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org
CC: Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
References: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu>
In-Reply-To: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-15 15:43, Vince Weaver wrote:
> 
> The following commit breaks building the kernel using the debian
> make-kpkg command
> 
> commit f4d4ffc03efc864645b990e1d579bbe1b8e358a4
> Author: Jason Cooper <jason@lakedaemon.net>
> Date:   Sun Dec 1 23:56:28 2013 +0000
> 
>     kbuild: dtbs_install: new make target
> 
> 
> If I run this:
> 	make-kpkg --initrd --rootcmd fakeroot kernel_image
> 
> After this commit it fails with:
> 
> make[2]: Entering directory `/home/vince/research/linux-kernel/linux-git'
> sh /home/vince/research/linux-kernel/linux-git/arch/x86/boot/install.sh 
> 3.14.0-rc6+ arch/x86/boot/bzImage \
> 		System.map 
> "/home/vince/research/linux-kernel/linux-git/debian/linux-image-3.14.0-rc6+//boot"
> run-parts: executing /etc/kernel/postinst.d/apt-auto-removal 3.14.0-rc6+ 
> /home/vince/research/linux-kernel/linux-git/debian/linux-image-3.14.0-rc6+//boot/vmlinuz-3.14.0-rc6+
> /etc/kernel/postinst.d/apt-auto-removal: 84: 
> /etc/kernel/postinst.d/apt-auto-removal: cannot create 
> /etc/apt/apt.conf.d//01autoremove-kernels.dpkg-new: Permission denied
> run-parts: /etc/kernel/postinst.d/apt-auto-removal exited with return code 
> 2

I fail to see how the above commit is responsible for this. make install
starts /sbin/installkernel and the rest is the job of this script. To
me, it looks more like a fakeroot failure than a bug in make install.

Michal
