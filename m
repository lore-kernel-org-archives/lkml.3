Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaAUMFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 07:05:15 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25372 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754082AbaAUMFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:05:14 -0500
Date: Tue, 21 Jan 2014 12:04:41 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 0/8] Update kernel uabi header files for x32
Message-ID: <20140121120440.GD14830@arm.com>
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
 <20131228163308.GA1638@infradead.org>
 <52DD6101.4010708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DD6101.4010708@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 05:46:41PM +0000, H. Peter Anvin wrote:
> On 12/28/2013 08:33 AM, Christoph Hellwig wrote:
> > On Fri, Dec 27, 2013 at 02:14:16PM -0800, H.J. Lu wrote:
> >> X32 uses the same kernel system call interface as x86-64 for many
> >> system calls.  However, "long" is 64-bit for x86-64 and is 32-bit for
> >> x32.  Where long or unsigned long are used in struct types for such
> >> system calls, they are wrong for x32.  __kernel_[u]long_t is [unsigned]
> >> long for all ABIs other than x32.  I am submitting 8 patches to replace
> >> long or unsigned long with __kernel_[u]long_t so that those struct types
> >> can be used with x32 system calls.

Does this mean that you are changing the x32 ABI (or it hasn't been
declared stable yet)?

> This comment by Christoph was literally the only feedback on this
> patchset.  The definition of __kernel_[u]long_t is "the size of 'long'
> for the native kernel for the ABI".  H.J.'s patchset only affects x86
> (specifically x86-64) since on all other platforms __kernel_[u]long_t is
> simply defined as long/unsigned long.
> 
> That being said, x32 is not the only ABI of this type.  In particular,
> if the MIPS N32 and ARM64 ILP32 maintainers have suggestions which would
> make this work more applicable to them, it would be highly useful to
> receive any such feedback.

ILP32 for arm64 is still work in progress and subject to change. So far
the preliminary ABI
(http://git.kernel.org/cgit/linux/kernel/git/cmarinas/linux-aarch64.git/log/?h=ilp32)
redefines kernel_(u)long_t is defined as (unsigned) long long. Most of
the syscalls are 64-bit generic with ~23 routed to compat. I would like
to simplify these further and even use native 64-bit signal handling but
it requires some changes to generic structures.

I'll have a look at H.J.'s patches and give comments, they may come in
handy.

-- 
Catalin
