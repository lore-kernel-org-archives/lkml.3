Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaHDC52 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 22:57:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38815 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaHDC50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 22:57:26 -0400
Message-ID: <53DEF67E.8090004@oracle.com>
Date: Sun, 03 Aug 2014 22:57:02 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Matt Mackall <mpm@selenic.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Jens Axboe <axboe@fb.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: kernel: smp: WARNING at kernel/smp.c:673
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:


[ 1226.701012] WARNING: CPU: 6 PID: 8624 at kernel/smp.c:673 on_each_cpu_cond+0x27f/0x2f0()
[ 1226.703128] Modules linked in:
[ 1226.703955] CPU: 6 PID: 8624 Comm: trinity-c26 Tainted: G        W      3.16.0-rc7-next-20140801-sasha-00047-gd6ce559 #991
[ 1226.706792]  ffff881b2e8a3000 0000000023830039 0000000000000000 ffff881b2e8a3000
[ 1226.708179]  ffff881ada5b3978 ffffffffa1ee96b4 0000000000000000 ffff881ada5b39b8
[ 1226.709610]  ffffffff9d1ce5ba ffffffff9d2c0ddf 000000000000001b ffff8807d7608000
[ 1226.710966] Call Trace:
[ 1226.711417] dump_stack (lib/dump_stack.c:52)
[ 1226.712311] warn_slowpath_common (kernel/panic.c:432)
[ 1226.715425] warn_slowpath_null (kernel/panic.c:466)
[ 1226.716436] on_each_cpu_cond (kernel/smp.c:673 (discriminator 3))
[ 1226.720821] __kmem_cache_shrink (mm/slub.c:3420)
[ 1226.722711] slab_memory_callback (mm/slub.c:3464 mm/slub.c:3556)
[ 1226.723925] notifier_call_chain (kernel/notifier.c:93)
[ 1226.725244] __blocking_notifier_call_chain (kernel/notifier.c:319)
[ 1226.726310] blocking_notifier_call_chain (kernel/notifier.c:329)
[ 1226.727263] memory_notify (drivers/base/memory.c:177)
[ 1226.728210] __offline_pages.constprop.23 (include/linux/notifier.h:179 mm/memory_hotplug.c:1682)
[ 1226.731896] offline_pages (mm/memory_hotplug.c:1787)
[ 1226.733095] memory_subsys_offline (drivers/base/memory.c:267 drivers/base/memory.c:304)
[ 1226.735208] device_offline (drivers/base/core.c:1428)
[ 1226.736966] online_store (drivers/base/core.c:451 (discriminator 2))
[ 1226.737720] dev_attr_store (drivers/base/core.c:138)
[ 1226.739986] sysfs_kf_write (fs/sysfs/file.c:116)
[ 1226.742105] kernfs_fop_write (fs/kernfs/file.c:308)
[ 1226.743058] do_loop_readv_writev (fs/read_write.c:708)
[ 1226.745095] do_readv_writev (fs/read_write.c:840)
[ 1226.752769] vfs_writev (fs/read_write.c:879)
[ 1226.753755] SyS_writev (fs/read_write.c:911 fs/read_write.c:903)
[ 1226.754660] tracesys (arch/x86/kernel/entry_64.S:541)

No time to dig too much into this today, will work on it tomorrow.


Thanks,
Sasha
