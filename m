Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaABEph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 23:45:37 -0500
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:48852
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaABEpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 23:45:36 -0500
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=Rs1LLUWK c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=LcaDllckn3IA:10 a=Rttt9Z-za7sA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=-PkhLDywX0wA:10
 a=85rfUPFjUj--iJOqae4A:9 a=SoHLJID-3jSoz0Zf:21 a=nBdCCjdwJPSwhqQr:21
 a=QEXdDO2ut3YA:10
Date: Thu, 2 Jan 2014 04:45:34 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Gene Heskett <gheskett@wdtv.com>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Subject: Re: AMD microcode fails to update with v3.8.3 and newer, bisect
 failed
Message-ID: <20140102044534.GA26440@milliways>
References: <201401011752.00267.gheskett@wdtv.com>
 <20140102001900.GC19878@titan.lakedaemon.net>
 <201401012125.55522.gheskett@wdtv.com>
 <20140102040815.GA25619@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140102040815.GA25619@milliways>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 04:08:15AM +0000, Ken Moffat wrote:
> 
>  Anyway, best of luck and I hope you get it sorted.
> 
 One further suggestion, since you appear to be at the "running
round in circles" stage -

1. Start with a good kernel.  In this case, I suppose 3.8.2 is the
right place to begin.

2. But then change the .config to -

2.1 ensure that your disk filesystems are built in - e.g. all of
ext2, ext3, ext4 and anything else you know you are using.
Normally, only the fs for '/' needs to be built in, but you seem to
have seen other issues so I would just build in everything you need.

2.2 build in everything else you need to boot (normally, the disk
controller(s) ) so that you don't need an initrd.

2.3 drop the things you don't need - this is merely to reduce the
time it takes to build a kernel.  Distros normally build
_everything_ as a module.  Provided you can boot without an initrd,
reducing the number of modules only makes it quicker to build a new
kernel - but if you are starting from something which looks like
"allmodconfig" it can save a lot of time.

2.4 for your convenience, ensure that you have enabled the config to
be stored in /proc/config.gz - once you are building your own
slimmed-down kernels, you probably won't want to mess about with
distro "install" scripts so just copying the bzimage to
/boot/vmlinuz-x.y.z, make modules_install, and editing
/boot/grub/grub.cfg (yes, really!) will save a lot of time.

2.5 Add your own version, e.g. for 3.8.2 change EXTRAVERSION to 2-A
so that the kernel will be 3.8.2-A (this stops it overwriting
existing existing 3.8.2 modules, in case the first attempt doesn't
do what you want).

3.  That might take two or three attempts to get to a good config,
but after that you should be able to use the slimmer config (from
zcat /proc/config.gz) to create .config for any newer version you
want to test or bisect, and then just run make oldconfig before you
build.

 Also, when you get back to bisecting, the version in the kernel
Makefile might not be what you expect.  If in doubt, you can change
it to something which doesn't overwrite any existing modules, e.g.
3.8.bisect-1 etc.

 HTH

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce
