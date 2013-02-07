Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab3BGQJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:09:46 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:49498 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab3BGQJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:09:45 -0500
MIME-Version: 1.0
In-Reply-To: <1360227230.13550.23.camel@ThinkPad-T5421.cn.ibm.com>
References: <1359714465-6297-1-git-send-email-zhong@linux.vnet.ibm.com>
	<1359714465-6297-2-git-send-email-zhong@linux.vnet.ibm.com>
	<CAFTL4hx7njUVVqp9FmtQQWaWG1i5dxscqQD8F_S838z2tUKVGQ@mail.gmail.com>
	<1360227230.13550.23.camel@ThinkPad-T5421.cn.ibm.com>
Date: Thu, 7 Feb 2013 17:09:43 +0100
Message-ID: <CAFTL4hwTqm541NfMjuF9kiUR6+PuMMnb5TnXzvEZieRgjggYgw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] powerpc: Syscall hooks for context tracking subsystem
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7 Li Zhong <zhong@linux.vnet.ibm.com>:
> On Thu, 2013-02-07 at 01:29 +0100, Frederic Weisbecker wrote:
>> In x86-64, schedule_user() and do_notify_resume() can be called before
>> syscall_trace_leave(). As a result we may be entering
>> syscall_trace_leave() in user mode (from a context tracking POV). To
>> fix this I added a call to user_exit() on the very beginning of that
>> function.
>>
>> You can find the details in 2c5594df344cd1ff0cc9bf007dea3235582b3acf
>> ("rcu: Fix unrecovered RCU user mode in syscall_trace_leave()").
>
> Hi Frederic,
>
> Thank you very much for the reminding.
>
>>
>> Could this problem happen in ppc as well?
>
> I checked the code(64 bit) today, it seems to me that it won't happen.
> But fortunately, we are in the ppc mailing list, please correct me if my
> understanding is wrong.

Ah indeed. Looking at syscall_exit_work label in entry_64.S,
do_syscall_trace_leave is called before ret_from_except which is where
we handle user preemption and do_notify_resume. So that looks fine.

>
> By the way, I enabled CONTEXT_TRACKING_FORCE and PROVE_RCU, so if it
> could happen, I think there should be some illegal RCU usage complaints
> reported.

Ok.

Thanks.
