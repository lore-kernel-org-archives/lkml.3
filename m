Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3KHIUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:20:02 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60874 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3KHITz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:19:55 -0500
From: Mikael Pettersson <mikpelinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21116.40614.511367.579373@gargle.gargle.HOWL>
Date: Fri, 8 Nov 2013 09:19:50 +0100
To: Yinghai Lu <yinghai@kernel.org>
Cc: Mikael Pettersson <mikpelinux@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG?] mtrr sanitizer fails on Latitude E6230
In-Reply-To: <CAE9FiQWPBBug_TWOnQRsSbTpaNPL9v5SsU33Akg2D47c6stHSw@mail.gmail.com>
References: <21114.2315.610902.200164@gargle.gargle.HOWL>
	<CAE9FiQX3mGLmzFCyaHYPBA2QgvxBYr9zarXcUKa5DC0ZtiiWZw@mail.gmail.com>
	<21115.20118.72541.74924@gargle.gargle.HOWL>
	<CAE9FiQWPBBug_TWOnQRsSbTpaNPL9v5SsU33Akg2D47c6stHSw@mail.gmail.com>
X-Mailer: VM 8.1.2 under 24.1.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu writes:
 > On Thu, Nov 7, 2013 at 12:25 AM, Mikael Pettersson <mikpelinux@gmail.com> wrote:
 > > Yinghai Lu writes:
 > >  > On Wed, Nov 6, 2013 at 1:16 AM, Mikael Pettersson <mikpelinux@gmail.com> wrote:
 > >  > > I recently got a Dell Latitude E6230 (Ivy Bridge i7-3540M) and noticed that
 > >  > > the mtrr sanitizer failed on it:
 > >  > >
 > >  > > === snip ===
 > >  > > Linux version 3.12.0 (mikpe@barley) (gcc version 4.8.3 20131017 (prerelease) (GCC) ) #1 SMP Wed Nov 6 09:46:02 CET 2013
 > >  > > Command line: ro root=LABEL=/ resume=/dev/sda2 rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=sv-latin1
 > >  > ...
 > >  > gran_size: 8M  chunk_size: 64M         num_reg: 9      lose cover RAM: 6M
 > >  > ...
 > >  > > mtrr_cleanup: can not find optimal value
 > >  > > please specify mtrr_gran_size/mtrr_chunk_size
 > >  > > === snip ===
 > >  > >
 > >  > > For now I'm disabling the mtrr sanitizer in this machine's kernel.
 > >  >
 > >  > Can you try to boot with "mtrr_gran_size=8m mtrr_chunk_size=64m" ?
 > >
 > > That results in:
 > >
 > > reg 0, base: 0GB, range: 8GB, type WB
 > > reg 1, base: 8GB, range: 512MB, type WB
 > > reg 2, base: 3584MB, range: 512MB, type UC
 > > reg 3, base: 3520MB, range: 64MB, type UC
 > > reg 4, base: 3512MB, range: 8MB, type UC
 > > reg 5, base: 8688MB, range: 16MB, type UC
 > > reg 6, base: 8680MB, range: 8MB, type UC
 > > reg 7, base: 8678MB, range: 2MB, type UC
 > > total RAM covered: 8094M
 > >  gran_size: 8M  chunk_size: 64M         num_reg: 9      lose cover RAM: 6M
 > > New variable MTRRs
 > > reg 0, base: 0GB, range: 2GB, type WB
 > > reg 1, base: 2GB, range: 1GB, type WB
 > > reg 2, base: 3GB, range: 256MB, type WB
 > > reg 3, base: 3328MB, range: 128MB, type WB
 > > reg 4, base: 3456MB, range: 64MB, type WB
 > > reg 5, base: 3512MB, range: 8MB, type UC
 > > reg 6, base: 4GB, range: 4GB, type WB
 > > reg 7, base: 8GB, range: 512MB, type WB
 > > reg 8, base: 8672MB, range: 32MB, type UC
 > > e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
 > > e820: update [mem 0x21e000000-0x21e5fffff] usable ==> reserved
 > ...
 > >> modified: [mem 0x000000021e000000-0x000000021e5fffff] reserved
 > 
 > that is right, it throw 6M away.
 > 
 > Did you notice any slowness or speeding for x window?

I'm not noticing any change.  i915 kernel driver + xorg's intel driver.

 > What does /proc/mtrr look like after xwindow is started?

reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg02: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back
reg03: base=0x0d0000000 ( 3328MB), size=  128MB, count=1: write-back
reg04: base=0x0d8000000 ( 3456MB), size=   64MB, count=1: write-back
reg05: base=0x0db800000 ( 3512MB), size=    8MB, count=1: uncachable
reg06: base=0x100000000 ( 4096MB), size= 4096MB, count=1: write-back
reg07: base=0x200000000 ( 8192MB), size=  512MB, count=1: write-back
reg08: base=0x21e000000 ( 8672MB), size=   32MB, count=1: uncachable

/Mikael
