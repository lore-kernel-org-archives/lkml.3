Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbbATOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:16:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbbATOP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:15:58 -0500
Message-ID: <54BE630E.4000901@redhat.com>
Date: Tue, 20 Jan 2015 09:15:42 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [PATCH 1/3] x86, fpu: __kernel_fpu_begin() should clear fpu_owner_task
 even if use_eager_fpu()
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com> <20150119185109.GA16427@redhat.com> <20150119185132.GB16427@redhat.com>
In-Reply-To: <20150119185132.GB16427@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 01:51 PM, Oleg Nesterov wrote:
> __kernel_fpu_begin() does nothing if !__thread_has_fpu() && use_eager_fpu(),
> perhaps it assumes that this case is simply impossible. This is certainly
> not possible if in_interrupt() == T; interrupted_user_mode() should have
> FPU, and interrupted_kernel_fpu_idle() should fail if !__thread_has_fpu().
>
> However, even if use_eager_fpu() == T a task can do drop_fpu(), then switch
> to another thread which becomes fpu_owner_task, then resume and call some
> function which does kernel_fpu_begin(). Say, an exiting task does a lot of
> things after exit_thread(), it is not safe to assume that it can't use FPU
> in these paths.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

