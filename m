Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3DRG2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 02:28:24 -0400
Received: from smtp01.mgmt.devclic.net ([91.198.44.61]:45742 "EHLO
	smtp01.mgmt.devclic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab3DRG2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 02:28:23 -0400
X-DSPAM-Result: Whitelisted
X-DSPAM-Confidence: 0.5734
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 1,516f9282269241804284693
X-DSPAM-Factors: 27,
X-Spam-Flag: NO
X-Spam-Score: -7.288
Message-ID: <516F9276.4020904@devclic.fr>
Date: Thu, 18 Apr 2013 08:28:06 +0200
From: Lilian - Devclic <lilian@devclic.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: INFO: task apache2:8693 blocked for more than 120 seconds
 with kernel 3.8.8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We upgraded kernel on all system of a cluster and have some troubles 
with Apache 2. The architecture is composed by 4 NFS clients and 1 NFS 
Server, all based on 3.8.8 kernel version ( before, it was 2.6.32 on all 
systems and was running with no problem )

Sometimes and after having reboot on kernel 3.8.8, NFS Clients display 
this trace in the dmesg :

[12100.793549] INFO: task apache2:8695 blocked for more than 120 seconds.
[12100.793577] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[12100.793621] apache2         D 0000000000000002     0  8695   7799 
0x00000000
[12100.793623]  ffff880215309d98 0000000000000086 ffff880215308010 
0000000000013940
[12100.793627]  ffff880215086300 0000000000013940 ffff880215309fd8 
0000000000013940
[12100.793630]  ffff880215309fd8 0000000000013940 ffff8802365418c0 
ffff880215086300
[12100.793633] Call Trace:
[12100.793636]  [<ffffffff815681f6>] schedule+0x64/0x66
[12100.793640]  [<ffffffff8156843e>] schedule_preempt_disabled+0xe/0x10
[12100.793643]  [<ffffffff81567190>] __mutex_lock_common+0x11d/0x18b
[12100.793646]  [<ffffffff8113dc27>] ? filename_lookup+0x74/0x84
[12100.793649]  [<ffffffff81567219>] __mutex_lock_slowpath+0x1b/0x1d
[12100.793652]  [<ffffffff81566fd5>] mutex_lock+0x1b/0x2c
[12100.793655]  [<ffffffff8113e76d>] do_unlinkat+0x92/0x231
[12100.793659]  [<ffffffff81131d7e>] ? fsnotify_access+0x5d/0x65
[12100.793662]  [<ffffffff81132f23>] ? sys_read+0x81/0x8e
[12100.793665]  [<ffffffff8113e922>] sys_unlink+0x16/0x18
[12100.793668]  [<ffffffff81570259>] system_call_fastpath+0x16/0x1b

The NFS Server exports a filesystem formatted in ReiserFS ( we mean it 
was the problem ) and we migrate to ext4, the problem is always present. 
I have one other architecture with a NFS Server based on a 2.6.24 Kernel 
and some clients with a 3.8.8 Kernel, the problem doesn't appear.

We made some tests with a 3.2 kernel and it was the same problem.

Can you give me some help ?

Thanks a lot.
Best Regards.
-- 
Lilian RIGARD - Devclic
Gérant - CEO & CTO
E-mail : lilian@devclic.fr <mailto:lilian@devclic.fr>
Web : http://www.devclic.fr
