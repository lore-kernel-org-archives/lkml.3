Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab3CYMn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:43:29 -0400
Received: from gherkin.frus.com ([192.158.254.49]:35532 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab3CYMn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:43:28 -0400
X-Greylist: delayed 1791 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 08:43:27 EDT
Date: Mon, 25 Mar 2013 07:13:35 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Cc: mcree@orcon.net.nz
Subject: [alpha] repeated Oops
Message-ID: <20130325121335.GA23024@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting lots of these since attempting to upgrade past 3.8.0-rc7.  I
*don't* think it's a kernel issue at this point, because while older
kernels (found an old 3.5.0-rc4 setup from about a year ago in my archives)
seem to take longer to reach this point, they'll eventually die exactly the
same way.  In other words, either my old hardware is starting to go bye-bye,
or something critical in userspace (libraries?) is horribly broken since the
last round of package updates (Debian unstable for alpha).

(System currently powered-down.  Will open the case later and go looking
for clogged/bad cooling fans, cat fur, etc.)

The process running at the time will vary, but the commonality I've
noticed is "lots of disk I/O".  Examples: cpio, applying the 3.9.0-rc1
kernel patch (approx. 40 MB uncompressed), running "git pull" on a local
kernel source repository where v3.8 was the most recent tag, the final link
of vmlinux on a kernel build, and so forth.

Reminder: this is a DEC Alpha system (PWS 433au).

Unable to handle kernel paging request at virtual address 0000000000000010
cpio(4445): Oops 0
pc = [<fffffc0000315d1c>]  ra = [<fffffc000031e2bc>]  ps = 0007    Not tainted
pc is at process_mcheck_info+0x4c/0x320
ra is at cia_machine_check+0x9c/0xb0
v0 = 0000000000000004  t0 = 0000000000000630  t1 = 0000000000000630
t2 = 0000000000000001  t3 = fffffc0000000000  t4 = fffffc00425ede38
t5 = fffffc00425ee000  t6 = 0000000000245b15  t7 = fffffc0042dbc000
s0 = 0000000000000000  s1 = fffffc00009ce258  s2 = fffffc00422b2498
s3 = fffffc0042dbfb68  s4 = 0000000000000002  s5 = 0000000000000002
s6 = 0000000000000002
a0 = 0000000000000630  a1 = 0000000000000000  a2 = fffffc00008aeb4c
a3 = 0000000000000000  a4 = fffffc0042dbfb68  a5 = fffffc0042dbfb58
t8 = 0000000000000001  t9 = 0000000000245b15  t10= fffffc00422b23b8
t11= 0000000000245b15  pv = fffffc0000315cd0  at = fffffc0042dbf878
gp = fffffc0000a0d0d8  sp = fffffc0042dbf8a0
Disabling lock debugging due to kernel taint
Trace:
[<fffffc000031e2bc>] cia_machine_check+0x9c/0xb0
[<fffffc000042fb40>] ext3_get_blocks_handle+0xe0/0xd00
[<fffffc0000315c70>] do_entInt+0x180/0x1e0
[<fffffc0000372704>] mempool_alloc_slab+0x24/0x40
[<fffffc0000310dc0>] ret_from_sys_call+0x0/0x10
[<fffffc00003729a0>] mempool_alloc+0x50/0x170
[<fffffc00003f18c4>] do_mpage_readpage+0x344/0x7e0
[<fffffc00004fb220>] __constant_c_memset+0x0/0x50
[<fffffc00004fb288>] loop+0x8/0x10
[<fffffc00003f1ee8>] mpage_readpages+0xf8/0x1c0
[<fffffc0000430760>] ext3_get_block+0x0/0x170
[<fffffc00004f0b3c>] radix_tree_insert+0x1ac/0x2f0
[<fffffc000036f550>] add_to_page_cache_locked+0xb0/0x180
[<fffffc00003f1eb8>] mpage_readpages+0xc8/0x1c0
[<fffffc0000430760>] ext3_get_block+0x0/0x170
[<fffffc000042c19c>] ext3_readpages+0x2c/0x40
[<fffffc00004545b0>] journal_stop+0x160/0x300
[<fffffc00004758d4>] security_file_open+0xa4/0xb0
[<fffffc000037b22c>] __do_page_cache_readahead+0x1fc/0x320
[<fffffc000037b798>] ra_submit+0x38/0x50
[<fffffc000037182c>] generic_file_aio_read+0x51c/0x800
[<fffffc00003adefc>] do_sync_read+0x9c/0x110
[<fffffc00003ae764>] vfs_read+0xb4/0x1c0
[<fffffc00004754e8>] security_file_permission+0xd8/0x110
[<fffffc00003ae204>] rw_verify_area+0x64/0x120
[<fffffc00003ae734>] vfs_read+0x84/0x1c0
[<fffffc00003ae8dc>] SyS_read+0x6c/0xc0
[<fffffc0000310da4>] entSys+0xa4/0xc0

Code: a75e0000  a53e0008  a55e0010  23de0020  6bfa8001  a55d0158 <a2910010> 261dffea

Thanks in advance for an assist in figuring out what's going on here.

--Bob
