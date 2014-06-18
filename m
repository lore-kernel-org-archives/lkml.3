Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbaFRGlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:41:37 -0400
Received: from fgwmail3.fujitsu.co.jp ([164.71.1.134]:59677 "EHLO
	fgwmail4.fujitsu.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933979AbaFRGld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:41:33 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2014 02:41:32 EDT
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53A132E2.9000605@jp.fujitsu.com>
Date: Wed, 18 Jun 2014 15:34:10 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <akpm@linux-foundation.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
CC: <tangchen@cn.fujitsu.com>, <toshi.kani@hp.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
        <guz.fnst@cn.fujitsu.com>, <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH 0/2] fix kernel panic on memory hotplug
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hot-adding memory after hot-removing memory, following call traces
are shown:

kernel BUG at arch/x86/mm/init_64.c:206!
...
 [<ffffffff815e0c80>] kernel_physical_mapping_init+0x1b2/0x1d2
 [<ffffffff815ced94>] init_memory_mapping+0x1d4/0x380
 [<ffffffff8104aebd>] arch_add_memory+0x3d/0xd0
 [<ffffffff815d03d9>] add_memory+0xb9/0x1b0
 [<ffffffff81352415>] acpi_memory_device_add+0x1af/0x28e
 [<ffffffff81325dc4>] acpi_bus_device_attach+0x8c/0xf0
 [<ffffffff813413b9>] acpi_ns_walk_namespace+0xc8/0x17f
 [<ffffffff81325d38>] ? acpi_bus_type_and_status+0xb7/0xb7
 [<ffffffff81325d38>] ? acpi_bus_type_and_status+0xb7/0xb7
 [<ffffffff813418ed>] acpi_walk_namespace+0x95/0xc5
 [<ffffffff81326b4c>] acpi_bus_scan+0x9a/0xc2
 [<ffffffff81326bff>] acpi_scan_bus_device_check+0x8b/0x12e
 [<ffffffff81326cb5>] acpi_scan_device_check+0x13/0x15
 [<ffffffff81320122>] acpi_os_execute_deferred+0x25/0x32
 [<ffffffff8107e02b>] process_one_work+0x17b/0x460
 [<ffffffff8107edfb>] worker_thread+0x11b/0x400
 [<ffffffff8107ece0>] ? rescuer_thread+0x400/0x400
 [<ffffffff81085aef>] kthread+0xcf/0xe0
 [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
 [<ffffffff815fc76c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140

The patch-sets fix the issue. The detailed descriptions are written
to the header of each patch.

