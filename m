Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3ANN1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 08:27:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab3ANN1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 08:27:41 -0500
Date: Mon, 14 Jan 2013 15:27:36 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Andrew Clayton <andrew@digital-domain.net>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: qemu-kvm hangs at start up under 3.8.0-rc3-00074-gb719f43 (works
 with CONFIG_LOCKDEP)
Message-ID: <20130114132736.GA12489@redhat.com>
References: <20130113222958.64840242@omega.digital-domain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130113222958.64840242@omega.digital-domain.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 10:29:58PM +0000, Andrew Clayton wrote:
> When running qemu-kvm under 64but Fedora 16 under current 3.8, it just
> hangs at start up. Dong a ps -ef hangs the process at the point where it
> would display the qemu process (trying to list the qemu-kvm /proc pid
> directory contents just hangs ls).
> 
> I also noticed some other weirdness at this point like Firefox hanging
> for many seconds at a time and increasing load average.
> 
> The qemu command I was trying to run was
> 
> $ qemu-kvm -m 512 -smp 2 -vga vmware -k en-gb -drive
> file=/home/andrew/machines/qemu/f16-i386.img,if=virtio
> 
> Here's the last few lines of a strace on it at start up.
> 
> open("/home/andrew/machines/qemu/f16-i386.img", O_RDWR|O_DSYNC|O_CLOEXEC) = 8
> lseek(8, 0, SEEK_END)                   = 9100722176
> pread(8, "QFI\373\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\20\0\0\0\2\200\0\0\0"..., 512, 0) = 512
> pread(8, "\200\0\0\0\0\4\0\0\200\0\0\0\0\10\0\0\200\0\0\0\2\210\0\0\200\0\0\0\2\233\0\0"..., 512, 65536) = 512
> brk(0)                                  = 0x7faf12db0000
> brk(0x7faf12ddd000
> 
> It's hanging in that brk syscall. The load average also then starts to increase.
> 
> 
> However. I can make it run fine, if I enable CONFIG_LOCKDEP. But the only
> thing in dmesg I get is the usual.
> 
> kvm: SMP vm created on host with unstable TSC; guest TSC will not be reliable
> 
> I've attached both working and non-working .configs. The only difference being
> the lock checking enabled in config.good.
> 
> The most recent kernel I had it working in was 3.7.0
> 
> System is a Quad Core Intel running 64bit Fedora 16.
> 
Can you run "echo t > /proc/sysrq-trigger" and see where it hangs?

--
			Gleb.
