Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3LZNwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 08:52:39 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:45824 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3LZNwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 08:52:37 -0500
MIME-Version: 1.0
In-Reply-To: <20131226100348.GA7751@infradead.org>
References: <20131225145447.GA18146@gmail.com>
	<20131226100348.GA7751@infradead.org>
Date: Thu, 26 Dec 2013 05:52:35 -0800
Message-ID: <CAMe9rOqx1HDT_rtiz2R0Cz5iAp0AFXhjw6RpTkjgFT_DDDWfVA@mail.gmail.com>
Subject: Re: [PATCH] Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 2:03 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Dec 25, 2013 at 06:54:47AM -0800, H.J. Lu wrote:
>> Both x32 and x86-64 use the same struct rusage and struct rlimit for
>> system calls.  But x32 log is 32-bit.  This patch change uapi
>> <linux/resource.h> to use __kernel_long_t in struct rusage and
>> __kernel_ulong_t in and struct rlimit.
>
>  a) please send all your related patches as a series

My patches are independent of each other.  They can
be applied in order.

>  b) explain how these changes to shared ABI headers:
>
>      1) do not break any architecture, especially mips N32 which is
>         the MIPS equivalent of x32

I am not familiar with N32 system call interface.  My patch
may break N32 if N32 __kernel_long_t doesn't match
what is used.  I will update my patches to limit my changes
to __BITS_PER_LONG == 64.

>      2) do not break existing x32 binaries
>      3) fix existing and future x32 binaries

My patches just update kernel uabi header files to match
x32 system calls.  They don't break any x32 binaries,
current and future.

>  c) why you suddenly need these changes now and not when the x32 ABI
>     support was submitted and hopefully heavily tested

Kernel headers had been wrong for -m32/-mx32 on x86-64
for a long long time.  Linux/x86-64 normally use header
files from glibc, which avoids broken kernel header files.
Kernel uabi header files fix -m32, but not -mx32, which I am
working on now.

Thanks.

-- 
H.J.
