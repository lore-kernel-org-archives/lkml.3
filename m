Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3DOGTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 02:19:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3DOGTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 02:19:13 -0400
Message-ID: <516B9B57.6050308@redhat.com>
Date: Mon, 15 Apr 2013 14:16:55 +0800
From: Zhouping Liu <zliu@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        caiqian <caiqian@redhat.com>, Caspar Zhang <czhang@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUG][s390x] mm: system crashed
References: <156480624.266924.1365995933797.JavaMail.root@redhat.com> <2068164110.268217.1365996520440.JavaMail.root@redhat.com> <20130415055627.GB4207@osiris>
In-Reply-To: <20130415055627.GB4207@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 01:56 PM, Heiko Carstens wrote:
> On Sun, Apr 14, 2013 at 11:28:40PM -0400, Zhouping Liu wrote:
>> Hi All,
>>
>> I hit the below crashed when doing memory related tests[1] on s390x:
>>
>> --------------- snip ---------------------
>> � 15929.351639¨  � <000000000021c0a6>¨ shrink_inactive_list+0x1c6/0x56c
>> � 15929.351647¨  � <000000000021c69e>¨ shrink_lruvec+0x252/0x56c
>> � 15929.351654¨  � <000000000021ca44>¨ shrink_zone+0x8c/0x1bc
>> � 15929.351662¨  � <000000000021d080>¨ balance_pgdat+0x50c/0x658
>> � 15929.351671¨  � <000000000021d318>¨ kswapd+0x14c/0x470
>> � 15929.351680¨  � <0000000000158292>¨ kthread+0xda/0xe4
>> � 15929.351690¨  � <000000000062a5de>¨ kernel_thread_starter+0x6/0xc
>> � 15929.351700¨  � <000000000062a5d8>¨ kernel_thread_starter+0x0/0xc
>> � 16109.346061¨ INFO: rcu_sched self-detected stall on CPU { 0}  (t=24006 jiffies
>>   g=89766 c=89765 q=10544)
>> � 16109.346101¨ CPU: 0 Tainted: G      D      3.9.0-rc6+ #1
>> � 16109.346106¨ Process kswapd0 (pid: 28, task: 000000003b2a0000, ksp: 000000003b
>> 2ab8c0)
>> � 16109.346110¨        000000000001bb60 000000000001bb70 0000000000000002 0000000
>> 000000000
>>         000000000001bc00 000000000001bb78 000000000001bb78 00000000001009ca
>>         0000000000000000 0000000000002930 000000000000000a 000000000000000a
>>         000000000001bbc0 000000000001bb60 0000000000000000 0000000000000000
>>         000000000063bb18 00000000001009ca 000000000001bb60 000000000001bbb0
>> � 16109.346170¨ Call Trace:
>> � 16109.346179¨ (� <0000000000100920>¨ show_trace+0x128/0x12c)
>> � 16109.346195¨  � <00000000001cd320>¨ rcu_check_callbacks+0x458/0xccc
>> � 16109.346209¨  � <0000000000140f2e>¨ update_process_times+0x4a/0x74
>> � 16109.346222¨  � <0000000000199452>¨ tick_sched_handle.isra.12+0x5e/0x70
>> � 16109.346235¨  � <00000000001995aa>¨ tick_sched_timer+0x6a/0x98
>> � 16109.346247¨  � <000000000015c1ea>¨ __run_hrtimer+0x8e/0x200
>> � 16109.346381¨  � <000000000015d1b2>¨ hrtimer_interrupt+0x212/0x2b0
>> � 16109.346385¨  � <00000000001040f6>¨ clock_comparator_work+0x4a/0x54
>> � 16109.346390¨  � <000000000010d658>¨ do_extint+0x158/0x15c
>> � 16109.346396¨  � <000000000062aa24>¨ ext_skip+0x38/0x3c
>> � 16109.346404¨  � <00000000001153c8>¨ smp_yield_cpu+0x44/0x48
>> � 16109.346412¨ (� <000003d10051aec0>¨ 0x3d10051aec0)
>> � 16109.346457¨  � <000000000024206a>¨ __page_check_address+0x16a/0x170
>> � 16109.346466¨  � <00000000002423a2>¨ page_referenced_one+0x3e/0xa0
>> � 16109.346501¨  � <000000000024427c>¨ page_referenced+0x32c/0x41c
>> � 16109.346510¨  � <000000000021b1dc>¨ shrink_page_list+0x380/0xb9c
>> � 16109.346521¨  � <000000000021c0a6>¨ shrink_inactive_list+0x1c6/0x56c
>> � 16109.346532¨  � <000000000021c69e>¨ shrink_lruvec+0x252/0x56c
>> � 16109.346542¨  � <000000000021ca44>¨ shrink_zone+0x8c/0x1bc
>> � 16109.346553¨  � <000000000021d080>¨ balance_pgdat+0x50c/0x658
>> � 16109.346564¨  � <000000000021d318>¨ kswapd+0x14c/0x470
>> � 16109.346576¨  � <0000000000158292>¨ kthread+0xda/0xe4
>> � 16109.346656¨  � <000000000062a5de>¨ kernel_thread_starter+0x6/0xc
>> � 16109.346682¨  � <000000000062a5d8>¨ kernel_thread_starter+0x0/0xc
>> [-- MARK -- Fri Apr 12 06:15:00 2013]
>> � 16289.386061¨ INFO: rcu_sched self-detected stall on CPU { 0}  (t=42010 jiffies
>>   g=89766 c=89765 q=10627)
> Did the system really crash or did you just see the rcu related warning(s)?

I just check it again, actually at first the system didn't really crash, 
but the system is very slow in response.
and the reproducer process can't be killed, after I did some common 
actions such as 'ls' 'vim' etc, the system
seemed to be really crashed, no any response.

also in the previous testing, I can remember that the system would be no 
any response for a long time, just only
repeatedly print out the such above 'Call Trace' into console.

Thanks,
Zhouping
