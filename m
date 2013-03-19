Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934406Ab3CSWoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:44:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933289Ab3CSWoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:44:15 -0400
Date: Tue, 19 Mar 2013 18:44:08 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: cpu offline causes backtrace from cmci_rediscover
Message-ID: <20130319224408.GB18152@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

offlining a CPU in 3.9-rc3 gets me this trace..

numa_remove_cpu cpu 1 node 0: mask now 0,2-3
smpboot: CPU 1 is now offline
BUG: using smp_processor_id() in preemptible [00000000] code: cpu-offline.sh/10591
caller is cmci_rediscover+0x6a/0xe0
Pid: 10591, comm: cpu-offline.sh Not tainted 3.9.0-rc3+ #2
Call Trace:
 [<ffffffff81333bbd>] debug_smp_processor_id+0xdd/0x100
 [<ffffffff8101edba>] cmci_rediscover+0x6a/0xe0
 [<ffffffff815f5b9f>] mce_cpu_callback+0x19d/0x1ae
 [<ffffffff8160ea66>] notifier_call_chain+0x66/0x150
 [<ffffffff8107ad7e>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff8104c2e3>] cpu_notify+0x23/0x50
 [<ffffffff8104c31e>] cpu_notify_nofail+0xe/0x20
 [<ffffffff815ef082>] _cpu_down+0x302/0x350
 [<ffffffff815ef106>] cpu_down+0x36/0x50
 [<ffffffff815f1c9d>] store_online+0x8d/0xd0
 [<ffffffff813edc48>] dev_attr_store+0x18/0x30
 [<ffffffff81226eeb>] sysfs_write_file+0xdb/0x150
 [<ffffffff811adfb2>] vfs_write+0xa2/0x170
 [<ffffffff811ae16c>] sys_write+0x4c/0xa0
 [<ffffffff81613019>] system_call_fastpath+0x16/0x1b

