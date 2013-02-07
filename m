Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422727Ab3BGWVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:21:14 -0500
Received: from infernal.debian.net ([176.28.9.132]:48232 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab3BGWVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:21:13 -0500
X-Greylist: delayed 1685 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2013 17:21:13 EST
Date: Thu, 7 Feb 2013 22:53:01 +0100
From: Andreas Bombe <aeb@debian.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, Dave Jones <davej@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: radeon causing sleeping function called from invalid context
Message-ID: <20130207215301.GA11773@amos.fritz.box>
References: <20130113012717.GA2673@redhat.com>
 <20130113113820.GA2503@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130113113820.GA2503@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 02:38:20PM +0300, Sergey Senozhatsky wrote:
> On (01/12/13 20:27), Dave Jones wrote:
> > BUG: sleeping function called from invalid context at mm/slub.c:925
> > in_atomic(): 1, irqs_disabled(): 0, pid: 566, name: Xorg
> > INFO: lockdep is turned off.
> > Pid: 566, comm: Xorg Not tainted 3.8.0-rc3+ #49
> > Call Trace:
> >  [<ffffffff81087ad1>] __might_sleep+0x141/0x200
> >  [<ffffffff8119eddb>] kmem_cache_alloc_trace+0x4b/0x2a0
> >  [<ffffffffa0083fb3>] ttm_bo_move_accel_cleanup+0x1d3/0x330 [ttm]
> >  [<ffffffffa00c5418>] radeon_move_blit.isra.4+0xf8/0x160 [radeon]
> >  [<ffffffffa00c5db0>] radeon_bo_move+0xb0/0x1f0 [radeon]
> >  [<ffffffffa00820ed>] ttm_bo_handle_move_mem+0x27d/0x5d0 [ttm]
> >  [<ffffffff8108dd51>] ? get_parent_ip+0x11/0x50
> >  [<ffffffffa0083307>] ttm_bo_move_buffer+0x127/0x140 [ttm]
> >  [<ffffffffa008717d>] ? ttm_eu_list_ref_sub+0x3d/0x60 [ttm]
> >  [<ffffffffa00833c2>] ttm_bo_validate+0xa2/0x120 [ttm]
> >  [<ffffffffa00c6f45>] radeon_bo_list_validate+0x75/0x90 [radeon]
> >  [<ffffffffa00dca22>] radeon_cs_ioctl+0x582/0x950 [radeon]
> >  [<ffffffffa002e573>] drm_ioctl+0x4d3/0x580 [drm]
> >  [<ffffffffa00dc4a0>] ? radeon_cs_finish_pages+0xf0/0xf0 [radeon]
> >  [<ffffffff811c49f9>] do_vfs_ioctl+0x99/0x5a0
> >  [<ffffffff812cd3d7>] ? file_has_perm+0x97/0xb0
> >  [<ffffffff81103715>] ? rcu_eqs_exit+0x65/0xb0
> >  [<ffffffff811c4f91>] sys_ioctl+0x91/0xb0
> >  [<ffffffff81695ad4>] tracesys+0xdd/0xe2
> > 
> 
> I see lots of these [mostly from page fault], the following one (quick and dirty) works for me.

Is that patch or any other fix being picked up? It's over three weeks
now and I'm still seeing those BUGs with the latest 3.8-rc.
