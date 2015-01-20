Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbbATOqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:46:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbbATOqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:46:39 -0500
Message-ID: <54BE6A41.5030004@redhat.com>
Date: Tue, 20 Jan 2015 09:46:25 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [PATCH 2/3] x86, fpu: always allow FPU in interrupt if use_eager_fpu()
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com> <20150119185109.GA16427@redhat.com> <20150119185151.GC16427@redhat.com>
In-Reply-To: <20150119185151.GC16427@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 01:51 PM, Oleg Nesterov wrote:
> The __thread_has_fpu() check in interrupted_kernel_fpu_idle() was needed
> to prevent the nested kernel_fpu_begin(). Now that we have in_kernel_fpu
> and !__thread_has_fpu() case in __kernel_fpu_begin() does not depend on
> use_eager_fpu() (except clts) we can remove it.
>
> __thread_has_fpu() can be false even if use_eager_fpu(), but this case
> does not differ from !use_eager_fpu() case except we should not worry
> about X86_CR0_TS, __kernel_fpu_begin/end will not touch this bit.
>
> Note: I think we can kill all irq_fpu_usable() checks except in_kernel_fpu,
> just we need to record the state of X86_CR0_TS in __kernel_fpu_begin() and
> conditionalize stts() in __kernel_fpu_end(), but this needs another patch.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

