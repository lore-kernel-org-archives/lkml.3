Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbbATOyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:54:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbbATOyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:54:05 -0500
Message-ID: <54BE6BFD.80603@redhat.com>
Date: Tue, 20 Jan 2015 09:53:49 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [PATCH 3/3] x86, fpu: don't abuse FPU in kernel threads if use_eager_fpu()
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com> <20150119185109.GA16427@redhat.com> <20150119185212.GD16427@redhat.com>
In-Reply-To: <20150119185212.GD16427@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 01:52 PM, Oleg Nesterov wrote:
> Afaics there is no reason why kernel threads should have FPU context
> even if use_eager_fpu() == T. Now that interrupted_kernel_fpu_idle()
> does not check __thread_has_fpu() we can remove the init_fpu() code
> from eager_fpu_init() and change flush_thread() called by do_execve()
> to initialize FPU.
>
> Note: of course, the change in flush_thread() is horrible and must be
> cleanuped. We need the new helper, and flush_thread() should return the
> error if init_fpu() fails.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Nice. This should help prevent us from loading and saving
the totally unused FPU state for things like idle threads
and other kernel threads.

Reviewed-by: Rik van Riel <riel@redhat.com>

