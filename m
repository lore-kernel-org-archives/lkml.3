Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaA1HG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 02:06:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:40888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbaA1HG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 02:06:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,734,1384329600"; 
   d="scan'208";a="445653655"
Message-ID: <52E755BB.9000201@intel.com>
Date: Tue, 28 Jan 2014 15:01:15 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v3 0/4] Intel MPX support
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <20140126081912.GA28831@gmail.com> <52E4C551.7020402@intel.com> <20140128064202.GA20869@gmail.com>
In-Reply-To: <20140128064202.GA20869@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 02:42 PM, Ingo Molnar wrote:
>
> * Ren Qiaowei <qiaowei.ren@intel.com> wrote:
>
>>>> MPX kernel code, namely this patchset, has mainly the 2
>>>> responsibilities: provide handlers for bounds faults (#BR), and
>>>> manage bounds memory.
>>>
>>> AFAICS the kernel side implementation causes no runtime overhead
>>> for non-MPX workloads, and also causes no runtime overhead for
>>> non-MPX hardware, right?
>>
>> Yes.
>
> Actually, I think that's not entirely true.
>
> For example if within the same mm there's a lot of non-MPX threads and
> an MPX thread, then the MMU notifier will be called for MMU operations
> of every non-MPX thread as well!
>
> So MPX state of a thread will slow down all the other non-MPX threads
> as well.
>
> The statement is only true for non-MPX tasks that have their separate
> mm's that does not have a single MPX thread.
>

Yes. Though all non-MPX threads are slowed down, the whole process 
benefit from MPX.

Anyway, HPA suggest these syscalls, which use MMU notifier, should be 
not needed, we can do what they do in userspace runtime. What do you 
think about it? I guess that I should remove the third patch which adds 
new prctl() syscalls in next version of this patchset.

Thanks,
Qiaowei
