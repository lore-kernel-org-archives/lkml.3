Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbaIZV5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:57:35 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43082 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252AbaIZV5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:57:32 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, tiwai@suse.de,
        tj@kernel.org, arjan@linux.intel.com
Cc: teg@jklm.no, rmilasan@suse.com, werner@suse.com, oleg@redhat.com,
        hare@suse.com, bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, mcgrof@suse.com, linux-kernel@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org
Subject: [PATCH v1 3/5] amd64_edac: enforce synchronous probe
Date: Fri, 26 Sep 2014 14:57:15 -0700
Message-Id: <1411768637-6809-4-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com>
References: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

While testing asynchronous PCI probe on this driver I noticed
it failed so enforce just synchronouse probe for now. Asynchronous
probe is not used by default and requires userepace intervention.
Patches for its support will be merged later.

[   14.411083] AMD64 EDAC driver v3.4.0
[   14.411156] bus: 'pci': probe for driver amd64_edac is run asynchronously
[   14.411308] really_probe: driver_sysfs_add(0000:00:18.2) failed
[   14.411354] ------------[ cut here ]------------
[   14.411398] WARNING: CPU: 4 PID: 224 at fs/kernfs/dir.c:1220 kernfs_remove_by_name_ns+0x83/0x90()
[   14.411446] kernfs: can not remove '0000:00:18.2', no directory
[   14.411484] Modules linked in: glue_helper(+) amd64_edac_mod(-) <etc>
[   14.413654] CPU: 4 PID: 224 Comm: kworker/u16:3 Not tainted 3.17.0-rc6+ #1
[   14.413695] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1605 10/25/2012
[   14.413809] Workqueue: events_unbound driver_attach_workfn
[   14.413909]  0000000000000009 ffffffff814d2cf9 ffff8803f0513d20 ffffffff81061972
[   14.414145]  0000000000000000
[   14.414254]  ffff8803f0513d70
[   14.414383]  ffffffffa032c068 0000000000000038
[   14.414507]  0000000000000000 ffffffff810619d7 ffffffff81723238 ffff880300000020
[   14.414701] Call Trace:
[   14.414746]  [<ffffffff814d2cf9>] ? dump_stack+0x41/0x51
[   14.414790]  [<ffffffff81061972>] ? warn_slowpath_common+0x72/0x90
[   14.414834]  [<ffffffff810619d7>] ? warn_slowpath_fmt+0x47/0x50
[   14.414880]  [<ffffffff814d0ac3>] ? printk+0x4f/0x51
[   14.414921]  [<ffffffff811f8593>] ? kernfs_remove_by_name_ns+0x83/0x90
[   14.415000]  [<ffffffff8137433d>] ? driver_sysfs_remove+0x1d/0x40
[   14.415046]  [<ffffffff81374a15>] ? driver_probe_device+0x1d5/0x250
[   14.415099]  [<ffffffff81374b4b>] ? __driver_attach+0x7b/0x80
[   14.415149]  [<ffffffff81374ad0>] ? __device_attach+0x40/0x40
[   14.415204]  [<ffffffff81372a13>] ? bus_for_each_dev+0x53/0x90
[   14.415254]  [<ffffffff81373913>] ? driver_attach_workfn+0x13/0x80
[   14.415298]  [<ffffffff81077403>] ? process_one_work+0x143/0x3c0
[   14.415342]  [<ffffffff81077a44>] ? worker_thread+0x114/0x480
[   14.415384]  [<ffffffff81077930>] ? rescuer_thread+0x2b0/0x2b0
[   14.415427]  [<ffffffff8107c261>] ? kthread+0xc1/0xe0
[   14.415468]  [<ffffffff8107c1a0>] ? kthread_create_on_node+0x170/0x170
[   14.415511]  [<ffffffff814d883c>] ? ret_from_fork+0x7c/0xb0
[   14.415554]  [<ffffffff8107c1a0>] ? kthread_create_on_node+0x170/0x170
[   14.415595] ---[ end trace dd11ab53a6e1ec0d ]---
[   14.415643] amd64_edac: probe of 0000:00:18.2 failed with error 0

Cc: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/edac/amd64_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index f8bf000..dc997ae 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2872,6 +2872,7 @@ static struct pci_driver amd64_pci_driver = {
 	.probe		= probe_one_instance,
 	.remove		= remove_one_instance,
 	.id_table	= amd64_pci_table,
+	.driver.sync_probe = true,
 };
 
 static void setup_pci_device(void)
-- 
2.1.0

