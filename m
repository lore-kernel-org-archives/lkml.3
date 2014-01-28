Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbaA1S1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:27:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33629 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298AbaA1S1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:27:04 -0500
Message-ID: <52E7F65D.4040503@zytor.com>
Date: Tue, 28 Jan 2014 10:26:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ren Qiaowei <qiaowei.ren@intel.com>, Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v3 0/4] Intel MPX support
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <20140126081912.GA28831@gmail.com> <52E4C551.7020402@intel.com> <20140128064202.GA20869@gmail.com> <52E755BB.9000201@intel.com>
In-Reply-To: <52E755BB.9000201@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 11:01 PM, Ren Qiaowei wrote:
> 
> Yes. Though all non-MPX threads are slowed down, the whole process
> benefit from MPX.
> 
> Anyway, HPA suggest these syscalls, which use MMU notifier, should be
> not needed, we can do what they do in userspace runtime. What do you
> think about it? I guess that I should remove the third patch which adds
> new prctl() syscalls in next version of this patchset.
> 

The syscalls is one thing, managing the bounds map in kernel space is
another.

We could manage the bounds map entirely in user space in a signal
handler, but that has both ABI issues (#BR currently turns into SIGSEGV
which is commonly hooked by applications; we could switch to a different
signal but there aren't many unclaimed ones) and performance issues.

I would think it would be extremely unusual for an application to have
some MPX and some non-MPX threads, since they would share the same
address space and the non-MPX threads would mess up the bounds.

	-hpa


