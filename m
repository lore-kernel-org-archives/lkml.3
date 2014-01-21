Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaAUMXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 07:23:05 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:58621 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaAUMXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:23:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140121120440.GD14830@arm.com>
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
	<20131228163308.GA1638@infradead.org>
	<52DD6101.4010708@zytor.com>
	<20140121120440.GD14830@arm.com>
Date: Tue, 21 Jan 2014 04:22:59 -0800
Message-ID: <CAMe9rOqL_TJW-XJz6e8_iewUypmsx8MXeaRfq-aATx3sFDBxcw@mail.gmail.com>
Subject: Re: [PATCH 0/8] Update kernel uabi header files for x32
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, Will Deacon <Will.Deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 4:04 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Mon, Jan 20, 2014 at 05:46:41PM +0000, H. Peter Anvin wrote:
>> On 12/28/2013 08:33 AM, Christoph Hellwig wrote:
>> > On Fri, Dec 27, 2013 at 02:14:16PM -0800, H.J. Lu wrote:
>> >> X32 uses the same kernel system call interface as x86-64 for many
>> >> system calls.  However, "long" is 64-bit for x86-64 and is 32-bit for
>> >> x32.  Where long or unsigned long are used in struct types for such
>> >> system calls, they are wrong for x32.  __kernel_[u]long_t is [unsigned]
>> >> long for all ABIs other than x32.  I am submitting 8 patches to replace
>> >> long or unsigned long with __kernel_[u]long_t so that those struct types
>> >> can be used with x32 system calls.
>
> Does this mean that you are changing the x32 ABI (or it hasn't been
> declared stable yet)?

We don't change x32 ABI.  Today kernel uabi header files are
incompatible with x32 ABI in user space.  My patches fix them
so that they can be used in user space.

-- 
H.J.
