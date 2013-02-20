Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935180Ab3BTUN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:13:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934553Ab3BTUN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:13:56 -0500
Date: Wed, 20 Feb 2013 15:13:48 -0500
From: Dave Jones <davej@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: odd GPF bug on resume from hibernate.
Message-ID: <20130220201348.GB3137@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130220192826.GA3137@redhat.com>
 <11452407.3H88HXekKp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11452407.3H88HXekKp@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 08:42:46PM +0100, Rafael J. Wysocki wrote:
 > On Wednesday, February 20, 2013 02:28:26 PM Dave Jones wrote:
 > > We had two users report hitting a bug that looks like this..
 > > 
 > > general protection fault: 8800 [#1] SMP 
 > > 
 > >    0:	ca 00 55             	lret   $0x5500
 > > 
 > > At this point I don't know where to begin debugging..
 > > 
 > > Is that 8800 error code a clue ?
 > 
 > Does CPU offline/online work on this machine?

I just asked the user to give that a try at https://bugzilla.redhat.com/show_bug.cgi?id=910162

Incidentally, I found that offlining a cpu in Linus' current tree
causes a mess..


numa_remove_cpu cpu 1 node 0: mask now 0,2-3
smpboot: CPU 1 is now offline
BUG: using smp_processor_id() in preemptible [00000000] code: bash/5976
caller is cmci_rediscover+0x6b/0xe0
Pid: 5976, comm: bash Not tainted 3.8.0-rc7+ #63
Call Trace:
 [<ffffffff812fb901>] debug_smp_processor_id+0xe1/0x100
 [<ffffffff8101e4bb>] cmci_rediscover+0x6b/0xe0
 [<ffffffff8158f55f>] mce_cpu_callback+0x1af/0x1c3
 [<ffffffff815a6893>] notifier_call_chain+0x53/0xa0
 [<ffffffff8107338e>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff810491e0>] __cpu_notify+0x20/0x40
 [<ffffffff81049215>] cpu_notify+0x15/0x20
 [<ffffffff8104939e>] cpu_notify_nofail+0xe/0x20
 [<ffffffff81588512>] _cpu_down+0x242/0x2b0
 [<ffffffff815885b6>] cpu_down+0x36/0x50
 [<ffffffff8158b4bd>] store_online+0x5d/0xe0
 [<ffffffff813c01b8>] dev_attr_store+0x18/0x30
 [<ffffffff81200ac0>] sysfs_write_file+0xe0/0x150
 [<ffffffff81191dcf>] vfs_write+0xaf/0x190
 [<ffffffff81192125>] sys_write+0x55/0xa0
 [<ffffffff815aa9d9>] system_call_fastpath+0x16/0x1b
BUG: using smp_processor_id() in preemptible [00000000] code: bash/5976
caller is cmci_rediscover+0x6b/0xe0
Pid: 5976, comm: bash Not tainted 3.8.0-rc7+ #63
Call Trace:
 [<ffffffff812fb901>] debug_smp_processor_id+0xe1/0x100
 [<ffffffff8101e4bb>] cmci_rediscover+0x6b/0xe0
 [<ffffffff8158f55f>] mce_cpu_callback+0x1af/0x1c3
 [<ffffffff815a6893>] notifier_call_chain+0x53/0xa0
 [<ffffffff8107338e>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff810491e0>] __cpu_notify+0x20/0x40
 [<ffffffff81049215>] cpu_notify+0x15/0x20
 [<ffffffff8104939e>] cpu_notify_nofail+0xe/0x20
 [<ffffffff81588512>] _cpu_down+0x242/0x2b0
 [<ffffffff815885b6>] cpu_down+0x36/0x50
 [<ffffffff8158b4bd>] store_online+0x5d/0xe0
 [<ffffffff813c01b8>] dev_attr_store+0x18/0x30
 [<ffffffff81200ac0>] sysfs_write_file+0xe0/0x150
 [<ffffffff81191dcf>] vfs_write+0xaf/0x190
 [<ffffffff81192125>] sys_write+0x55/0xa0
 [<ffffffff815aa9d9>] system_call_fastpath+0x16/0x1b
BUG: using smp_processor_id() in preemptible [00000000] code: bash/5976
caller is cmci_rediscover+0x6b/0xe0
Pid: 5976, comm: bash Not tainted 3.8.0-rc7+ #63
Call Trace:
 [<ffffffff812fb901>] debug_smp_processor_id+0xe1/0x100
 [<ffffffff8101e4bb>] cmci_rediscover+0x6b/0xe0
 [<ffffffff8158f55f>] mce_cpu_callback+0x1af/0x1c3
 [<ffffffff815a6893>] notifier_call_chain+0x53/0xa0
 [<ffffffff8107338e>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff810491e0>] __cpu_notify+0x20/0x40
 [<ffffffff81049215>] cpu_notify+0x15/0x20
 [<ffffffff8104939e>] cpu_notify_nofail+0xe/0x20
 [<ffffffff81588512>] _cpu_down+0x242/0x2b0
 [<ffffffff815885b6>] cpu_down+0x36/0x50
 [<ffffffff8158b4bd>] store_online+0x5d/0xe0
 [<ffffffff813c01b8>] dev_attr_store+0x18/0x30
 [<ffffffff81200ac0>] sysfs_write_file+0xe0/0x150
 [<ffffffff81191dcf>] vfs_write+0xaf/0x190
 [<ffffffff81192125>] sys_write+0x55/0xa0
 [<ffffffff815aa9d9>] system_call_fastpath+0x16/0x1b
BUG: using smp_processor_id() in preemptible [00000000] code: bash/5976
caller is cmci_discover+0x25/0x260
Pid: 5976, comm: bash Not tainted 3.8.0-rc7+ #63
Call Trace:
 [<ffffffff812fb901>] debug_smp_processor_id+0xe1/0x100
 [<ffffffff8101de25>] cmci_discover+0x25/0x260
 [<ffffffff81005575>] ? show_trace+0x15/0x20
 [<ffffffff815950c4>] ? dump_stack+0x77/0x80
 [<ffffffff8102444b>] ? lapic_get_maxlvt+0x1b/0x30
 [<ffffffff8101e112>] cmci_rediscover_work_func+0x22/0x30
 [<ffffffff8101e527>] cmci_rediscover+0xd7/0xe0
 [<ffffffff8158f55f>] mce_cpu_callback+0x1af/0x1c3
 [<ffffffff815a6893>] notifier_call_chain+0x53/0xa0
 [<ffffffff8107338e>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff810491e0>] __cpu_notify+0x20/0x40
 [<ffffffff81049215>] cpu_notify+0x15/0x20
 [<ffffffff8104939e>] cpu_notify_nofail+0xe/0x20
 [<ffffffff81588512>] _cpu_down+0x242/0x2b0
 [<ffffffff815885b6>] cpu_down+0x36/0x50
 [<ffffffff8158b4bd>] store_online+0x5d/0xe0
 [<ffffffff813c01b8>] dev_attr_store+0x18/0x30
 [<ffffffff81200ac0>] sysfs_write_file+0xe0/0x150
 [<ffffffff81191dcf>] vfs_write+0xaf/0x190
 [<ffffffff81192125>] sys_write+0x55/0xa0
 [<ffffffff815aa9d9>] system_call_fastpath+0x16/0x1b

 
