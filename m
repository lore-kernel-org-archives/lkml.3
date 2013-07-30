Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab3G3LrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:47:10 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51722 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752478Ab3G3LrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:47:07 -0400
Date: Tue, 30 Jul 2013 12:46:01 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Robert Richter <rric@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jed Davis <jld@mozilla.com>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
 [OT]
Message-ID: <20130730114601.GE2478@localhost.localdomain>
References: <1373685501-1620-1-git-send-email-jld@mozilla.com>
 <20130715135420.GG10000@mudshark.cambridge.arm.com>
 <20130720044655.GC9433@mozilla.com>
 <20130721213753.GA29879@mudshark.cambridge.arm.com>
 <20130722185234.GA14519@localhost.localdomain>
 <20130729212140.GB12681@mozilla.com>
 <20130730092517.GB2478@localhost.localdomain>
 <20130730113853.46cbb00a@armhf>
 <20130730094457.GC2478@localhost.localdomain>
 <20130730120907.6dcc469e@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130730120907.6dcc469e@armhf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 12:09:07PM +0200, Jean-Francois Moine wrote:
> On Tue, 30 Jul 2013 10:44:57 +0100
> Dave Martin <Dave.Martin@arm.com> wrote:
> 
> > On Tue, Jul 30, 2013 at 11:38:53AM +0200, Jean-Francois Moine wrote:
> > > On Tue, 30 Jul 2013 10:25:18 +0100
> > > Dave Martin <Dave.Martin@arm.com> wrote:
> > >   
> > > > The pragmatic route is less contraversial and lower overhead: even though
> > > > it's not correct as per the ABI, GCC is the only supported compiler for
> > > > building the kernel anyway.  
> > > 
> > > BTW, kernels compiled with gcc-4.8 don't work.  
> > 
> > I haven't tried 4.8 yet.  Do you know what the problem is?
> 
> I randomly get 'NULL pointer dereference' in ext3 (trace below).
> 
> I compared the gcc-4.6 and gcc-4.8 ARM codes of the function where the
> problem occurs, and, while the gcc-4.8 code seems a bit odd, the
> problem should be somewhere else, surely in the memory management.
> 
> > > Did anybody succeed with clang?  
> > 
> > Hmm, I've no idea.  Is this possible?
> 
> freebsd kernels are compiled with clang, and I heard about linux
> patches, but I did not find them yet.

Given the tricks the kernel has to pull with undocumented features of
inline asm and the like, the prospect of dropping in a different
compiler is more than a little scary...

> Otherwise, replacing gcc with clang in the main kernel Makefile stops
> on an assembly instruction where odd register numbers could not be
> used. I did not go further.

Hmm.  Dunno what this is... but I guess it's nothing to do with
backtraces.

Cheers
---Dave

> 
> ------------------ gcc-4.8.1 kernel oops ----------------
> Unable to handle kernel NULL pointer dereference at virtual address 00000003
> pgd = bcf74000
> [00000003] *pgd=3cf16831, *pte=00000000, *ppte=00000000
> Internal error: Oops: 811 [#1] PREEMPT ARM
> Modules linked in: arc4 p54usb p54common crc_ccitt mac80211 cfg80211 fbcon bitblit softcursor font snd_soc_spdif_tx tda998x dove_drm drm_kms_helper snd_soc_kirkwood mv_cesa drm snd_soc_kirkwood_spdif
> CPU: 0 PID: 2426 Comm: iceweasel Not tainted 3.10.0-dirty #55
> task: bd92b700 ti: bcf48000 task.ti: bcf48000
> PC is at do_mpage_readpage+0x754/0x888
> LR is at bio_add_page+0x44/0x4c
> pc : [<800e3c70>]    lr : [<800db8ac>]    psr: 600f0113
> sp : bcf49c34  ip : bcf49c88  fp : bcf49c5c
> r10: 00000003  r9 : 00000000  r8 : 00000043
> r7 : 00000001  r6 : 800e3f54  r5 : bcf49c30  r4 : 00000003
> r3 : 00020000  r2 : 00000042  r1 : 00000000  r0 : bcf49c5c
> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 10c5387d  Table: 3cf74019  DAC: 00000015
> Process iceweasel (pid: 2426, stack limit = 0xbcf48240)
> Stack: (0xbcf49c34 to 0xbcf4a000)
> 9c20:                                              00000020 bcf49d24 00200200
> 9c40: 00100100 bd580d94 00000000 80de4260 bcf49cf4 bcf49c60 800e3e78 800e3528
> 9c60: bcf49c88 bcf49c7c 801164cc 000000c1 804d660c 801164cc da0716b4 00000042
> 9c80: 00000000 00000000 00000020 00000000 80de4260 000000c1 00287ab6 00000000
> 9ca0: 00020000 80073500 bd402c80 804d6670 00100100 00000002 00200200 8039a2ac
> 9cc0: 804d660c 00000002 804d6ca0 80113f84 00000020 00000020 00000042 000000b4
> 9ce0: 00000000 00000020 bcf49d04 bcf49cf8 80113fa8 800e3db0 bcf49d6c bcf49d08
> 9d00: 80079ef4 80113f90 bcf00c00 00000018 bd580d94 00000020 bd580d98 bcf49d24
> 9d20: 00000001 80de4394 80de4254 91827364 bcf49d30 bcf49d30 bcf49d38 bcf49d38
> 9d40: 00000052 00000052 bcf00c00 bd580d94 bd580d94 bcf49df0 00000000 bcf6c0d0
> 9d60: bcf49d84 bcf49d70 8007a600 80079d10 00000008 7319d000 bcf49ddc bcf49d88
> 9d80: 800719f4 8007a5dc 80076670 80075448 00000001 000000c1 bcf00c48 00000002
> 9da0: 3c5e818f 00000000 bcf48008 bd580ce0 80013e40 bcf6c0d0 bdbc2e40 00000000
> 9dc0: 7319d000 00000028 00000000 bcf75cc0 bcf49e2c bcf49de0 8008b0ac 8007163c
> 9de0: bdb247a8 00000000 00000000 00000200 00000028 00000052 7319d000 00000000
> 9e00: 8007b8d0 bcf6c0d0 7319d000 7319d000 bdbc2e40 bcf6c0d0 00000028 00000000
> 9e20: bcf49e7c bcf49e30 8008e584 8008b048 00000052 00000028 00000000 000000b1
> 9e40: da538506 000000b1 804bb718 00000004 804bb708 bcf74000 00000398 7319d000
> 9e60: bdbc2e40 bcf6c0d0 00000028 bcf75cc0 bcf49eb4 bcf49e80 8008ed14 8008e51c
> 9e80: bcf75cc0 00000028 da538506 00000017 bcf49fb0 bdbc2e40 bd92b700 7319d288
> 9ea0: bcf48038 00000028 bcf49efc bcf49eb8 80013c38 8008ec80 0000b533 00000000
> 9ec0: 0000b533 00000200 00000000 bdbc2e78 00000000 00000017 80013a64 804b76f4
> 9ee0: 7319d288 bcf49fb0 00000ea1 00000000 bcf49fac bcf49f00 80008460 80013a70
> 9f00: bcf00c00 00000001 000b45c0 804bc488 bcf48000 00000000 0000001d 00000000
> 9f20: 00000001 73098000 bcf49f54 804bc488 bcf49f54 bcf49f40 8006a284 8006b524
> 9f40: 804bb900 bcf48028 00000000 00000000 0000001d 00000000 bcf49f7c bcf49f68
> 9f60: 80022424 8006db18 00020000 804c3c90 bcf49f9c bcf49f80 8000ec2c 800223a4
> 9f80: 00000621 75253ff0 200f0030 75238ed2 200f0030 ffffffff 00000000 00000ea1
> 9fa0: 00000000 bcf49fb0 8000e118 8000842c 7319d2ec 7319d292 7ee06c98 7319d288
> 9fc0: 7ee06c98 73098000 00000000 00000000 00000ea1 00000ea1 00000000 73223be0
> 9fe0: 752811fc 7ee06b88 7523bd75 75238ed2 200f0030 ffffffff 00000000 00000000
> Backtrace: 
> [<800e351c>] (do_mpage_readpage+0x0/0x888) from [<800e3e78>] (mpage_readpages+0xd4/0x130)
> [<800e3da4>] (mpage_readpages+0x0/0x130) from [<80113fa8>] (ext3_readpages+0x24/0x28)
> [<80113f84>] (ext3_readpages+0x0/0x28) from [<80079ef4>] (__do_page_cache_readahead+0x1f0/0x2d8)
> [<80079d04>] (__do_page_cache_readahead+0x0/0x2d8) from [<8007a600>] (ra_submit+0x30/0x38)
> [<8007a5d0>] (ra_submit+0x0/0x38) from [<800719f4>] (filemap_fault+0x3c4/0x4b0)
> [<80071630>] (filemap_fault+0x0/0x4b0) from [<8008b0ac>] (__do_fault+0x70/0x4a8)
> [<8008b03c>] (__do_fault+0x0/0x4a8) from [<8008e584>] (handle_pte_fault+0x74/0x764)
> [<8008e510>] (handle_pte_fault+0x0/0x764) from [<8008ed14>] (handle_mm_fault+0xa0/0xd4)
> [<8008ec74>] (handle_mm_fault+0x0/0xd4) from [<80013c38>] (do_page_fault+0x1d4/0x278)
> [<80013a64>] (do_page_fault+0x0/0x278) from [<80008460>] (do_DataAbort+0x40/0xa0)
> [<80008420>] (do_DataAbort+0x0/0xa0) from [<8000e118>] (__dabt_usr+0x38/0x40)
> Exception stack(0xbcf49fb0 to 0xbcf49ff8)
> 9fa0:                                     7319d2ec 7319d292 7ee06c98 7319d288
> 9fc0: 7ee06c98 73098000 00000000 00000000 00000ea1 00000ea1 00000000 73223be0
> 9fe0: 752811fc 7ee06b88 7523bd75 75238ed2 200f0030 ffffffff
>  r8:00000ea1 r7:00000000 r6:ffffffff r5:200f0030 r4:75238ed2
> Code: e0854184 e51b0084 e14424d8 e51b40a0 (e1c420f0) 
> ---[ end trace 838796f906351fb0 ]---
> 
> 
> -- 
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
