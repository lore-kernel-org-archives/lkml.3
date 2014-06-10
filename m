Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaFJNYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:24:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22087 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbaFJNYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:24:20 -0400
Message-ID: <5397078B.9040206@fb.com>
Date: Tue, 10 Jun 2014 09:26:35 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ed Tomlinson <edt@aei.ca>, Sasha Levin <sasha.levin@oracle.com>
CC: <jbacik@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs: hang on boot due to tests
References: <5395CFE6.10804@oracle.com> <5395D9D6.3080101@fb.com> <5395DE2E.7080700@oracle.com> <3216820.JOp565CquS@grover>
In-Reply-To: <3216820.JOp565CquS@grover>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_05:2014-06-10,2014-06-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.3818667311003e-09 kscore.compositescore=0
 circleOfTrustscore=26.272755790097 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406100160
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/10/2014 07:14 AM, Ed Tomlinson wrote:
> On Monday 09 June 2014 12:17:50 Sasha Levin wrote:
>> On 06/09/2014 11:59 AM, Chris Mason wrote:
>>> On 06/09/2014 11:16 AM, Sasha Levin wrote:
>>>>> Hi all,
>>>>>
>>>>> It seems that some recent changes to btrfs tests make it hang during boot:
>>>>>
>>>>> [   49.730033] NMI watchdog: BUG: soft lockup - CPU#34 stuck for 23s! [swapper/0:1]
>>>>> [   49.730033] Modules linked in:
>>>>> [   49.730033] hardirqs last enabled at (6389143): restore_args (arch/x86/kernel/entry_64.S:829)
>>>>> [   49.730033] hardirqs last disabled at (6389144): apic_timer_interrupt (arch/x86/kernel/entry_64.S:1021)
>>>>> [   49.730033] softirqs last enabled at (6389142): __do_softirq (./arch/x86/include/asm/preempt.h:22 kernel/softirq.c:296)
>>>>> [   49.730033] softirqs last disabled at (6389139): irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
>>>>> [   49.730033] CPU: 34 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc8-next-20140606-sasha-00021-ga9d3a0b-dirty #597
>>>
>>> This is 3.15-rc8 + linux-next?  I'll try to reproduce here, but the
>>> tests were working for me.
>>
>> Yes, it's the latest -next tree available.
>>
>> Also note that it doesn't happen every time, so might be some sort of a race?
> 
> I've noticed that with -rc8 and now .15 btrfs fails to automount (or mount) about 1 in 2 times requiring a reboot to get it to work.
> I have not seen anything in logs.  Might this be related?

It shouldn't be, the lockup Sasha hit is only in the self testing code,
and he's triggering it in the qgroups self tests.

Do you have CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y?

I'd love a sysrq-t or sysrq-w while you're stuck.

-chris
