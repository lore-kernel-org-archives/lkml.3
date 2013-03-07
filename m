Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3CGGC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:02:59 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52271 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811Ab3CGGC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:02:58 -0500
X-Sasl-enc: 1Yjv1EDrPx+w/pup2K5+FCAhRXyY3/d4ZUX53SlUh4Ih 1362636177
Date: Thu, 7 Mar 2013 14:03:28 +0800
From: Greg Kroah-Hartman <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: sysfs_dir_cache slab corruption
Message-ID: <20130307060328.GB31738@kroah.com>
References: <20130307052854.GA23745@redhat.com>
 <20130307053353.GA24287@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307053353.GA24287@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 12:33:53AM -0500, Dave Jones wrote:
> And even more sysfs fallout (From a clean boot)..
> 
> =============================================================================
> BUG sysfs_dir_cache (Not tainted): Poison overwritten
> -----------------------------------------------------------------------------
> 
> Disabling lock debugging due to kernel taint
> INFO: 0xffff8801239a85b8-0xffff8801239a85b8. First byte 0x69 instead of 0x6b
> INFO: Allocated in sysfs_new_dirent+0x59/0x130 age=493166 cpu=3 pid=301
> 	__slab_alloc+0x4ed/0x584
> 	kmem_cache_alloc+0x2c0/0x330
> 	sysfs_new_dirent+0x59/0x130
> 	sysfs_add_file_mode+0x6b/0x110
> 	sysfs_add_file+0x12/0x20
> 	sysfs_create_file+0x26/0x30
> 	load_module+0x1360/0x28d0
> 	sys_init_module+0xd7/0x120
> 	system_call_fastpath+0x16/0x1b
> INFO: Freed in release_sysfs_dirent+0x81/0x100 age=10736 cpu=3 pid=8692
> 	__slab_free+0x3c/0x3de
> 	kmem_cache_free+0x362/0x380
> 	release_sysfs_dirent+0x81/0x100
> 	sysfs_dir_pos+0x46/0xf0
> 	sysfs_readdir+0x9a/0x2b0
> 	vfs_readdir+0xb8/0xf0
> 	sys_getdents64+0x8f/0x110
> 	system_call_fastpath+0x16/0x1b
> INFO: Slab 0xffffea00048e6a00 objects=16 used=16 fp=0x          (null) flags=0x5000000000004080
> INFO: Object 0xffff8801239a85b8 @offset=1464 fp=0x          (null)
> 
> Bytes b4 ffff8801239a85a8: 00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
> Object ffff8801239a85b8: 69 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  ikkkkkkkkkkkkkkk
> Object ffff8801239a85c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff8801239a85d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff8801239a85e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff8801239a85f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff8801239a8608: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff8801239a8618: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff8801239a8628: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff8801239a8638: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff8801239a8648: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
> Redzone ffff8801239a8658: bb bb bb bb bb bb bb bb                          ........
> Padding ffff8801239a8798: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
> Pid: 15728, comm: modprobe Tainted: G    B        3.9.0-rc1+ #69
> Call Trace:
>  [<ffffffff8118e81d>] ? print_section+0x3d/0x40
>  [<ffffffff8118f98e>] print_trailer+0xfe/0x160
>  [<ffffffff8118fb2f>] check_bytes_and_report+0xef/0x130
>  [<ffffffff81190126>] check_object+0x1c6/0x240
>  [<ffffffff81190989>] ? check_slab+0x89/0x130
>  [<ffffffff81235159>] ? sysfs_new_dirent+0x59/0x130
>  [<ffffffff816bb755>] alloc_debug_processing+0x67/0x109
>  [<ffffffff816bc2ee>] __slab_alloc+0x4ed/0x584
>  [<ffffffff81235159>] ? sysfs_new_dirent+0x59/0x130
>  [<ffffffff811926f0>] kmem_cache_alloc+0x2c0/0x330
>  [<ffffffff81235159>] ? sysfs_new_dirent+0x59/0x130
>  [<ffffffff81235159>] sysfs_new_dirent+0x59/0x130
>  [<ffffffff812343eb>] sysfs_add_file_mode+0x6b/0x110
>  [<ffffffff81237620>] internal_create_group+0xd0/0x210
>  [<ffffffff81237793>] sysfs_create_group+0x13/0x20
>  [<ffffffff810c71f1>] load_module+0x22d1/0x28d0
>  [<ffffffff81355570>] ? ddebug_proc_open+0xc0/0xc0
>  [<ffffffff810b24ae>] ? put_lock_stats.isra.23+0xe/0x40
>  [<ffffffff810c78c7>] sys_init_module+0xd7/0x120
>  [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
> FIX sysfs_dir_cache: Restoring 0xffff8801239a85b8-0xffff8801239a85b8=0x6b
> 

Hm, a module was being loaded.  Odd, I haven't seen this before, I'm
guessing that 3.8 doesn't show this, right?

greg k-h
