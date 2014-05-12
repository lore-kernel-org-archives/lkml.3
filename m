Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaELS7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:59:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23539 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaELS7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:59:03 -0400
Message-ID: <537119EF.2060102@oracle.com>
Date: Mon, 12 May 2014 14:58:55 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>
Subject: workqueue: WARN at at kernel/workqueue.c:2176
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following spew:

[ 1297.886670] WARNING: CPU: 0 PID: 190 at kernel/workqueue.c:2176 process_one_work+0xb5/0x6f0()
[ 1297.889216] Modules linked in:
[ 1297.890306] CPU: 0 PID: 190 Comm: kworker/3:0 Not tainted 3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
[ 1297.893258]  0000000000000009 ffff88010c5d7ce8 ffffffffb153e1ec 0000000000000002
[ 1297.893258]  0000000000000000 ffff88010c5d7d28 ffffffffae15fd6c ffff88010cdd6c98
[ 1297.893258]  ffff8806285d4000 ffffffffb3cd09e0 ffff88010cdde000 0000000000000000
[ 1297.893258] Call Trace:
[ 1297.893258] dump_stack (lib/dump_stack.c:52)
[ 1297.893258] warn_slowpath_common (kernel/panic.c:430)
[ 1297.893258] warn_slowpath_null (kernel/panic.c:465)
[ 1297.893258] process_one_work (kernel/workqueue.c:2174 (discriminator 38))
[ 1297.893258] worker_thread (kernel/workqueue.c:2354)
[ 1297.893258] ? rescuer_thread (kernel/workqueue.c:2303)
[ 1297.893258] kthread (kernel/kthread.c:210)
[ 1297.893258] ? kthread_create_on_node (kernel/kthread.c:176)
[ 1297.893258] ret_from_fork (arch/x86/kernel/entry_64.S:553)
[ 1297.893258] ? kthread_create_on_node (kernel/kthread.c:176)


Thanks,
Sasha
