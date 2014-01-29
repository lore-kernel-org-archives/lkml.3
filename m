Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaA2M66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 07:58:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaA2M65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 07:58:57 -0500
Date: Wed, 29 Jan 2014 04:59:50 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Zhang, Jun" <jun.zhang@intel.com>
Cc: "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] firmware: give a protection when map page failed
Message-ID: <20140129125950.GA1727@kroah.com>
References: <88DC34334CA3444C85D647DBFA962C271160BE8E@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88DC34334CA3444C85D647DBFA962C271160BE8E@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 02:23:47AM +0000, Zhang, Jun wrote:
> >From 9c23aedc1c1a1446dae96ffec8f20a2f52942281 Mon Sep 17 00:00:00 2001
> From: jzha144 <jun.zhang@intel.com>
> Date: Wed, 29 Jan 2014 09:57:05 +0800
> Subject: [PATCH] firmware: give a protection when map page failed

What is that mess?

Please don't make me hand-edit your patch, when dealing with patches
that the scale we have to, that's not ok.  Just use 'git send-email' and
all should be fine.

> 
> [ 7341.474236] [drm:do_intel_finish_page_flip] *ERROR* invalid or inactive unpin_work!
> [ 7341.494464] atomisp-css2400b0_v21 0000:00:03.0: unhandled css stored event: 0x20
> [ 7341.503627] vmap allocation for size 208896 failed: use vmalloc=<size> to increase size.<=================== map failed
> [ 7341.507135] [drm:do_intel_finish_page_flip] *ERROR* invalid or inactive unpin_work!
> [ 7341.503848] BUG: unable to handle kernel NULL pointer dereference at   (null)
> [ 7341.520394] IP: [<c18f5c1b>] sst_load_all_modules_elf+0x1bb/0x850
> [ 7341.527216] *pdpt = 0000000030dfe001 *pde = 0000000000000000
> [ 7341.533640] Oops: 0000 [#1] PREEMPT SMP
> [ 7341.540360] [drm:do_intel_finish_page_flip] *ERROR* invalid or inactive unpin_work!
> [ 7341.538037] Modules linked in: atomisp_css2400b0_v21 lm3554 ov2722 imx1x5 atmel_mxt_ts vxd392 videobuf_vmalloc videobuf_core lm_dump(O) bcm_bt_lpm hdmi_audio bcm4334x(O)
> [ 7341.563531] CPU: 1 PID: 525 Comm: mediaserver Tainted: G        W  O 3.10.20-262518-ga83c053 #1
> [ 7341.573253] task: f0994ec0 ti: f09f0000 task.ti: f09f0000
> [ 7341.579284] EIP: 0060:[<c18f5c1b>] EFLAGS: 00010246 CPU: 1
> [ 7341.585415] EIP is at sst_load_all_modules_elf+0x1bb/0x850
> [ 7341.591541] EAX: 00000000 EBX: e3595ba0 ECX: 00000000 EDX: 00031c1c
> [ 7341.598541] ESI: e04a0000 EDI: 00000000 EBP: f09f1d80 ESP: f09f1cf4
> [ 7341.605542]  DS: 007b ES: 007b FS: 00d8 GS: 003b SS: 0068
> [ 7341.611573] CR0: 80050033 CR2: 00000000 CR3: 30db4000 CR4: 001007f0
> [ 7341.618573] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [ 7341.625575] DR6: ffff0ff0 DR7: 00000400
> [ 7341.629856] Stack:
> [ 7341.632097]  f09f1d57 00000019 c1d656d7 c1d658d3 c1d56409 00000f28 c1d64af9 18000103
> [ 7341.640766]  01000001 00080000 c1f910a0 f326f4c8 00000034 f326f520 00000002 e04a02bc
> [ 7341.649465]  00000001 f326e014 c1f910b0 e04a0000 c0080100 00031c1c e3595ba0 c0080100
> [ 7341.658149] Call Trace:
> [ 7341.660888]  [<c18f6308>] sst_post_download_byt+0x58/0xb0
> [ 7341.666925]  [<c18f4fbc>] sst_load_fw+0xdc/0x510
> [ 7341.672086]  [<c1a7b2c0>] ? __mutex_lock_slowpath+0x250/0x370
> [ 7341.678507]  [<c1a80e05>] ? sub_preempt_count+0x55/0xe0
> [ 7341.684346]  [<c18f1294>] sst_download_fw+0x14/0x60
> [ 7341.689796]  [<c1a7b403>] ? mutex_lock+0x23/0x30
> [ 7341.694954]  [<c18f191c>] intel_sst_check_device+0x6c/0x120
> [ 7341.701181]  [<c18f1d08>] sst_set_generic_params+0x1b8/0x4a0
> [ 7341.707504]  [<c1a80e05>] ? sub_preempt_count+0x55/0xe0
> [ 7341.713341]  [<c1a80e05>] ? sub_preempt_count+0x55/0xe0
> [ 7341.719178]  [<c1a7b2c0>] ? __mutex_lock_slowpath+0x250/0x370
> [ 7341.725600]  [<c1320d84>] ? __kmalloc_track_caller+0xe4/0x1d0
> [ 7341.732022]  [<c18e35f5>] sst_set_mixer_param+0x25/0x40
> [ 7341.737859]  [<c18e3853>] lpe_mixer_ihf_set+0xb3/0x160
> [ 7341.743602]  [<c1855b99>] snd_ctl_ioctl+0xa89/0xb40
> [ 7341.749052]  [<c1331e65>] ? path_openat+0xa5/0x3d0
> [ 7341.754409]  [<c1447857>] ? avc_has_perm_flags+0xc7/0x170
> [ 7341.760441]  [<c1855110>] ? snd_ctl_elem_add_user+0x540/0x540
> [ 7341.766862]  [<c1334047>] do_vfs_ioctl+0x77/0x5e0
> [ 7341.772117]  [<c144842a>] ? inode_has_perm.isra.42.constprop.79+0x3a/0x50
> [ 7341.779705]  [<c14490a0>] ? file_has_perm+0xa0/0xb0
> [ 7341.785155]  [<c14493b8>] ? selinux_file_ioctl+0x48/0xe0
> [ 7341.791090]  [<c1334628>] SyS_ioctl+0x78/0x90
> [ 7341.795958]  [<c1a7dde8>] syscall_call+0x7/0xb
> [ 7341.800925]  [<c1a70000>] ? mm_fault_error+0x13c/0x198

All you do is include an oops here, which tells me nothing.

> Signed-off-by: jzha144 <jun.zhang@intel.com>

I some how doubt this is really your name given that it differs from
your "From:" line above.

Intel has kernel developers who are very willing to look at patches from
other Intel people, so that simple problems like this are fixed before
annoying grumpy maintainers.  Please use them.

greg k-h
