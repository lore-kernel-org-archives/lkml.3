Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3KURW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:22:27 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48043 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KURWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:22:25 -0500
MIME-Version: 1.0
In-Reply-To: <20131121150344.GG10022@twins.programming.kicks-ass.net>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
	<tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
	<CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
	<20131121150344.GG10022@twins.programming.kicks-ass.net>
Date: Thu, 21 Nov 2013 09:22:24 -0800
X-Google-Sender-Auth: D0hF5X6cFt_CmPXoGOQxlpn_uJs
Message-ID: <CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 7:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> This one seems fix NULL reference in compute_group_power.
>>
>> but get following on current Linus tree plus tip/sched/urgent.
>>
>> divide error: 0000 [#1]  SMP
>> [   28.190477] Modules linked in:
>> [   28.192012] CPU: 11 PID: 484 Comm: kworker/u324:0 Not tainted
>> 3.12.0-yh-10487-g4b94e59-dirty #2044
>> [   28.210488] Hardware name: Oracle Corporation  Sun Fire
>> [   28.229877] task: ffff88ff25205140 ti: ffff88ff2520a000 task.ti:
>> ffff88ff2520a000
>> [   28.236139] RIP: 0010:[<ffffffff810d9ff4>]  [<ffffffff810d9ff4>]
>> find_busiest_group+0x2b4/0x8a0
>
> Hurmph.. what kind of hardware is that? and is there anything funny you
> do to make it do this?

intel nehanem-ex or westmere-ex 8 sockets system.

I tried without my local patches, the problem is still there.

Yinghai
