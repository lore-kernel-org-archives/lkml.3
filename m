Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbbAOTU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:20:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbbAOTUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:20:24 -0500
Date: Thu, 15 Jan 2015 20:19:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: [PATCH 0/3] x86, fpu: kernel_fpu_begin/end initial cleanups/fix
Message-ID: <20150115191918.GA27332@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421012793-30106-1-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cc's.

On 01/11, riel@redhat.com wrote:
>
> Currently the kernel will always load the FPU context, even
> when switching to a kernel thread, or to an idle thread. In
> the case of a task on a KVM VCPU going idle for a bit, and
> waking up again later, this creates a vastly inefficient
> chain of FPU context saves & loads:

I assume you will send v2.

Let me send initial kernel_fpu_begin/end cleanups, I believe they make
sense anyway and won't conflict with your changes.

This is actually resend, I sent more patches some time ago but they were
ignored.

Note that (I hope) we can do more changes on top of this series, in
particular:

	- remove all checks from irq_fpu_usable() except in_kernel_fpu

	- do not abuse FPU in kernel threads, this makes sense even if
	  use_eager_fpu(), and with or without the changes you proposed.

Please review.

Oleg.

