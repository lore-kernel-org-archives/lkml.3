Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130Ab3CZNXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:23:31 -0400
Received: from gherkin.frus.com ([192.158.254.49]:36491 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933705Ab3CZNX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:23:29 -0400
Date: Tue, 26 Mar 2013 08:23:23 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [alpha] repeated Oops
Message-ID: <20130326132323.GA31139@gherkin.frus.com>
References: <20130325121335.GA23024@gherkin.frus.com>
 <20130326091618.GA6014@omega>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326091618.GA6014@omega>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 10:16:18PM +1300, Michael Cree wrote:
> On Mon, Mar 25, 2013 at 07:13:35AM -0500, Bob Tracy wrote:
> > Getting lots of these since attempting to upgrade past 3.8.0-rc7.  I
> > *don't* think it's a kernel issue at this point, because while older
> > kernels (found an old 3.5.0-rc4 setup from about a year ago in my archives)
> > seem to take longer to reach this point, they'll eventually die exactly the
> > same way.
> 
> Presumably the older kernel has worked reliably at some stage?

It was reliable enough to hook up an external USB hard drive and create
a back-up, which was a non-trivial undertaking at the time on the PWS :-).

> > (System currently powered-down.  Will open the case later and go looking
> > for clogged/bad cooling fans, cat fur, etc.)
> 
> Good idea.  Check motherboard is well seated into I/O board.  Check memory 
> is all well seated.  Doing that got me some extra life out of my PWS!

Opened the case last night and found the expected amount of (which is to
say, too much) cat, dog, and carpet fur on the air-intake grates in
front of the two fans on the front of the machine.  Power supply intake
vents had *some* crud on them, but not severe.  The rest of the machine
interior looked good.  All fans operational.  Frankly, I've seen much
worse.

Bottom line: still getting Oopses as below.  At least they're
consistent.  The first one is normally followed immediately by one or
two more (usually having to do with "scheduling while atomic, etc.),
depending on what is running at the time.  If I let the machine set idle
after booting (except for stopping kdm, postgresql, apache2, samba,
winbind), it will happily behave itself for hours (days?  dunno...
can't seem to leave it alone that long for some reason :-( ).  If I do
an "apt-get upgrade", sometimes I get through it ok, and sometimes not.
I'm on my fifth reboot trying to get 3.9.0-rc4 built after having to
restore my kernel source tree because applying the 3.9.0-rc1 patch
(all 40 some odd MB of it) caused an Oops roughly half-way through the
process: that one was particularly nasty -- filesystem corruption got
cleaned up ok by fsck on the reboot, but the contents of many blocks
allocated to files that got updated hadn't been flushed to disk, so many
of the patched files ended up containing fragments of unrelated files
and/or nulls.  Cleaning up that kind of corruption without a recent
backup or access to an appropriate "git" repo is well nigh impossible.

Rarely, the Oops will lock things up bad enough I have to hit the reset
switch (the kernel source patch episode above).  Most of the time, I can
perform an orderly shutdown.

I suppose if I had a bit of a clue, the consistency of what's happening
would be enough to say, "*there's* your problem."  One would think that
the Oopses would be a bit more random if they're being caused by flaky
hardware (as opposed to badness that is a bit more "immutable" in nature).
You mentioned reseating memory and the I/O board, and I didn't do that
when I had the case open: probably should have.

> > The process running at the time will vary, but the commonality I've
> > noticed is "lots of disk I/O".  Examples: cpio, applying the 3.9.0-rc1
> > kernel patch (approx. 40 MB uncompressed), running "git pull" on a local
> > kernel source repository where v3.8 was the most recent tag, the final link
> > of vmlinux on a kernel build, and so forth.
> > 
> > Reminder: this is a DEC Alpha system (PWS 433au).
> > 
> > Unable to handle kernel paging request at virtual address 0000000000000010
> > cpio(4445): Oops 0
> > pc = [<fffffc0000315d1c>]  ra = [<fffffc000031e2bc>]  ps = 0007    Not tainted
> > pc is at process_mcheck_info+0x4c/0x320
> > ra is at cia_machine_check+0x9c/0xb0
> > v0 = 0000000000000004  t0 = 0000000000000630  t1 = 0000000000000630
> > t2 = 0000000000000001  t3 = fffffc0000000000  t4 = fffffc00425ede38
> > t5 = fffffc00425ee000  t6 = 0000000000245b15  t7 = fffffc0042dbc000
> > s0 = 0000000000000000  s1 = fffffc00009ce258  s2 = fffffc00422b2498
> > s3 = fffffc0042dbfb68  s4 = 0000000000000002  s5 = 0000000000000002
> > s6 = 0000000000000002
> > a0 = 0000000000000630  a1 = 0000000000000000  a2 = fffffc00008aeb4c
> > a3 = 0000000000000000  a4 = fffffc0042dbfb68  a5 = fffffc0042dbfb58
> > t8 = 0000000000000001  t9 = 0000000000245b15  t10= fffffc00422b23b8
> > t11= 0000000000245b15  pv = fffffc0000315cd0  at = fffffc0042dbf878
> > gp = fffffc0000a0d0d8  sp = fffffc0042dbf8a0
> > Disabling lock debugging due to kernel taint
> > Trace:
> > [<fffffc000031e2bc>] cia_machine_check+0x9c/0xb0
> > [<fffffc000042fb40>] ext3_get_blocks_handle+0xe0/0xd00
> > [<fffffc0000315c70>] do_entInt+0x180/0x1e0
> > [<fffffc0000372704>] mempool_alloc_slab+0x24/0x40
> > [<fffffc0000310dc0>] ret_from_sys_call+0x0/0x10
> > [<fffffc00003729a0>] mempool_alloc+0x50/0x170
> > [<fffffc00003f18c4>] do_mpage_readpage+0x344/0x7e0
> > [<fffffc00004fb220>] __constant_c_memset+0x0/0x50
> > [<fffffc00004fb288>] loop+0x8/0x10
> > [<fffffc00003f1ee8>] mpage_readpages+0xf8/0x1c0
> > [<fffffc0000430760>] ext3_get_block+0x0/0x170
> > [<fffffc00004f0b3c>] radix_tree_insert+0x1ac/0x2f0
> > [<fffffc000036f550>] add_to_page_cache_locked+0xb0/0x180
> > [<fffffc00003f1eb8>] mpage_readpages+0xc8/0x1c0
> > [<fffffc0000430760>] ext3_get_block+0x0/0x170
> > [<fffffc000042c19c>] ext3_readpages+0x2c/0x40
> > [<fffffc00004545b0>] journal_stop+0x160/0x300
> > [<fffffc00004758d4>] security_file_open+0xa4/0xb0
> > [<fffffc000037b22c>] __do_page_cache_readahead+0x1fc/0x320
> > [<fffffc000037b798>] ra_submit+0x38/0x50
> > [<fffffc000037182c>] generic_file_aio_read+0x51c/0x800
> > [<fffffc00003adefc>] do_sync_read+0x9c/0x110
> > [<fffffc00003ae764>] vfs_read+0xb4/0x1c0
> > [<fffffc00004754e8>] security_file_permission+0xd8/0x110
> > [<fffffc00003ae204>] rw_verify_area+0x64/0x120
> > [<fffffc00003ae734>] vfs_read+0x84/0x1c0
> > [<fffffc00003ae8dc>] SyS_read+0x6c/0xc0
> > [<fffffc0000310da4>] entSys+0xa4/0xc0
> > 
> > Code: a75e0000  a53e0008  a55e0010  23de0020  6bfa8001  a55d0158 <a2910010> 261dffea
> > 
> > Thanks in advance for an assist in figuring out what's going on here.
> > 
> > --Bob
