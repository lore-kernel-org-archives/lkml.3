Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaJATaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:30:18 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33808 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaJATaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:30:16 -0400
MIME-Version: 1.0
Date: Wed, 1 Oct 2014 12:30:15 -0700
Message-ID: <CAKx2Y1nFvUqvDMMAeAV8mn8nmPaMU3f3PUjVotbmfazMdMexLw@mail.gmail.com>
Subject: 3.17.0-rc7 kernel NULL pointer dereference
From: Kui Zhang <kuizhang@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have been getting NULL pointer dereference error, with 3.17.0-rc7,
built from commit aad7fb916a10f1065ad23de0c80a4a04bcba8437

I don't know how to reproduce this. It seem to happen during high io
load (sometimes). I got follow via usb a serial console, not sure if
trace is complete.


[12660.20467[12660.205958] kworker/u8:5    D ffff8803b3123020     0
23992      2 0x00000000
[12660.206000] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[12660.206035]  ffff8803ad30fb18 0000000000000002 ffff8803ad30fa78
ffff8803b3123020
[12660.206117]  ffff8803ad30ffd8 0000000000004000 ffff8800b1a00000
ffff8803b3123020
[12660.206183]  ffff88035d346000 0000000000000000 ffff8803ad30fa78
ffff8800927a6940
[12660.206244] Call Trace:
[12660.206277]  [<ffffffff8137c1aa>] ? btrfs_leaf_free_space+0x5a/0xc0
[12660[12772.061906] BTRFS info (device sda2): The free space cache
file (914857394176) is invalid. skip it
[12772.061906]
[12772.113733] BTRFS info (device sda2): The free space cache file
(1032968994816) is invalid. skip it
[12772.113733]
[17981.856115] perf interrupt took too long (4994 > 4960), lowering
kernel.perf_event_max_sample_rate to 25200
[27826.446614] EXT4-fs (md0): mounting ext3 file system using the ext4 subsystem
[27826.580071] EXT4-fs (md0): mounted filesystem with ordered data
mode. Opts: (null)
[50418.016235] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000018
[50418.016321] IP: [<ffffffff8149e080>] swiotlb_unmap_sg_attrs+0x30/0x70
[50418.016368] PGD 1f5dd4067 PUD 346dd3067 PMD 0
[50418.016403] Oops: 0000 [#1] SMP
[50418.016435] Modules linked in: cpuid nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack serio_raw microcode
[50418.016512] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G          I
3.17.0-rc7-backup5001 #11
[50418.016567] Hardware name: empty empty/S5393, BIOS V1.05 04/24/2009
[50418.016601] task: ffff880429568000 t[    0.000000] Initializing
cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct


Anything I can due to narrow down the problem ?


Thanks
Kui.Z
