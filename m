Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaAURHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:07:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38581 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbaAURHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:07:46 -0500
Message-ID: <52DEA933.6080907@zytor.com>
Date: Tue, 21 Jan 2014 09:06:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>, LKML <linux-kernel@vger.kernel.org>
CC: linux-arch <linux-arch@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/8] Update kernel uabi header files for x32
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
In-Reply-To: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2013 02:14 PM, H.J. Lu wrote:
> X32 uses the same kernel system call interface as x86-64 for many
> system calls.  However, "long" is 64-bit for x86-64 and is 32-bit for
> x32.  Where long or unsigned long are used in struct types for such
> system calls, they are wrong for x32.  __kernel_[u]long_t is [unsigned]
> long for all ABIs other than x32.  I am submitting 8 patches to replace
> long or unsigned long with __kernel_[u]long_t so that those struct types
> can be used with x32 system calls.
> 
> H.J. Lu (8):
>   Use __kernel_long_t in struct timex
>   Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
>   Use __kernel_ulong_t in uapi struct ipc64_perm
>   Use __kernel_long_t in struct msgbuf
>   Use __kernel_ulong_t in struct msqid64_ds
>   Use __kernel_ulong_t in x86 struct semid64_ds
>   Use __kernel_ulong_t in shmid64_ds/shminfo64/shm_info
>   Use __kernel_long_t in struct mq_attr
> 

As Catalin indirectly pointed out, I had made a followup to the wrong
version of the patchset (because I commented to Christoph's feedback.)
This is threaded to the proper version (without unnecessary #if
__BITS_PER_LONG.)

	-hpa
