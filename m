Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaEMCSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 22:18:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42776 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaEMCSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 22:18:22 -0400
Message-ID: <537180B9.6080407@oracle.com>
Date: Mon, 12 May 2014 22:17:29 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <537119EF.2060102@oracle.com> <20140512200135.GL1421@htj.dyndns.org> <53718119.1090000@cn.fujitsu.com>
In-Reply-To: <53718119.1090000@cn.fujitsu.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 10:19 PM, Lai Jiangshan wrote:
> On 05/13/2014 04:01 AM, Tejun Heo wrote:
>> > On Mon, May 12, 2014 at 02:58:55PM -0400, Sasha Levin wrote:
>>> >> Hi all,
>>> >>
>>> >> While fuzzing with trinity inside a KVM tools guest running the latest -next
>>> >> kernel I've stumbled on the following spew:
>>> >>
>>> >> [ 1297.886670] WARNING: CPU: 0 PID: 190 at kernel/workqueue.c:2176 process_one_work+0xb5/0x6f0()
>>> >> [ 1297.889216] Modules linked in:
>>> >> [ 1297.890306] CPU: 0 PID: 190 Comm: kworker/3:0 Not tainted 3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
>>> >> [ 1297.893258]  0000000000000009 ffff88010c5d7ce8 ffffffffb153e1ec 0000000000000002
>>> >> [ 1297.893258]  0000000000000000 ffff88010c5d7d28 ffffffffae15fd6c ffff88010cdd6c98
>>> >> [ 1297.893258]  ffff8806285d4000 ffffffffb3cd09e0 ffff88010cdde000 0000000000000000
>>> >> [ 1297.893258] Call Trace:
>>> >> [ 1297.893258] dump_stack (lib/dump_stack.c:52)
>>> >> [ 1297.893258] warn_slowpath_common (kernel/panic.c:430)
>>> >> [ 1297.893258] warn_slowpath_null (kernel/panic.c:465)
>>> >> [ 1297.893258] process_one_work (kernel/workqueue.c:2174 (discriminator 38))
>>> >> [ 1297.893258] worker_thread (kernel/workqueue.c:2354)
>>> >> [ 1297.893258] kthread (kernel/kthread.c:210)
>>> >> [ 1297.893258] ret_from_fork (arch/x86/kernel/entry_64.S:553)
> Hi,
> 
> I have been trying to address this bug.
> Buy I can't reproduce this bug. Is your testing arch X86?
> if yes, could you find out how to reproduce the bug?

Yup, it's a 64bit KVM guest.

I don't have an easy way to reproduce it as I only saw the bug once, but
it happened when I started pressuring CPU hotplug paths by adding and removing
CPUs often. Maybe it has anything to do with that?


Thanks,
Sasha

