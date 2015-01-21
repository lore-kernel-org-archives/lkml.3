Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbbAUO3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:29:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbbAUO3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:29:31 -0500
From: Paul Moore <pmoore@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [fs] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(1,0)
Date: Wed, 21 Jan 2015 09:29:27 -0500
Message-ID: <2014590.Q7f0SpfhCT@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1421825538.6126.28.camel@intel.com>
References: <1421825538.6126.28.camel@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 03:32:18 PM Huang Ying wrote:
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 5dc5218840e1268de639150a851978bb19c341df ("fs: create proper filename
> objects using getname_kernel()")
> 
> [   16.813397] 010f           65536 ram15  (driver?)
> [   16.815041] fc00       268435456 vda  driver: virtio_blk
> [   16.816777] fc10       268435456 vdb  driver: virtio_blk
> [   16.818544] Kernel panic - not syncing: VFS: Unable to mount root fs on
> unknown-block(1,0) [   16.819520] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> 3.19.0-rc5-next-20150120-g5d0eebb #799 [   16.819520] Hardware name: QEMU
> Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf
> 04/01/2014 [   16.819520]  ffff8800076a0000 ffff880006f47db8
> ffffffff81b7a16b ffffffff810cf061 [   16.819520]  ffffffff81fd6ce5
> ffff880006f47e38 ffffffff81b749fd ffffffff822459b0 [   16.819520] 
> ffff880000000010 ffff880006f47e48 ffff880006f47de8 ffff003500626476 [  
> 16.819520] Call Trace:
> [   16.819520]  [<ffffffff81b7a16b>] dump_stack+0x4c/0x65
> [   16.819520]  [<ffffffff810cf061>] ? console_unlock+0x398/0x3c7
> [   16.819520]  [<ffffffff81b749fd>] panic+0xc9/0x1f7
> [   16.819520]  [<ffffffff824e84aa>] mount_block_root+0x201/0x218
> [   16.819520]  [<ffffffff824e871f>] mount_root+0x13f/0x14a
> [   16.819520]  [<ffffffff824e92fc>] ? initrd_load+0x2d7/0x2e6
> [   16.819520]  [<ffffffff824e8897>] prepare_namespace+0x16d/0x1a6
> [   16.819520]  [<ffffffff824e815a>] kernel_init_freeable+0x268/0x278
> [   16.819520]  [<ffffffff81b6bb61>] ? rest_init+0xca/0xca
> [   16.819520]  [<ffffffff81b6bb6f>] kernel_init+0xe/0xda
> [   16.819520]  [<ffffffff81b881fc>] ret_from_fork+0x7c/0xb0
> [   16.819520]  [<ffffffff81b6bb61>] ? rest_init+0xca/0xca
> [   16.819520] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range:
> 0xffffffff80000000-0xffffffff9fffffff)

Thanks for reporting the problem, we're currently working on a fix:

 * https://lkml.org/lkml/2015/1/20/710

-- 
paul moore
security @ redhat

