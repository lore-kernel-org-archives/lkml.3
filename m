Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3L1QdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 11:33:20 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3L1QdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 11:33:19 -0500
Date: Sat, 28 Dec 2013 08:33:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Update kernel uabi header files for x32
Message-ID: <20131228163308.GA1638@infradead.org>
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 02:14:16PM -0800, H.J. Lu wrote:
> X32 uses the same kernel system call interface as x86-64 for many
> system calls.  However, "long" is 64-bit for x86-64 and is 32-bit for
> x32.  Where long or unsigned long are used in struct types for such
> system calls, they are wrong for x32.  __kernel_[u]long_t is [unsigned]
> long for all ABIs other than x32.  I am submitting 8 patches to replace
> long or unsigned long with __kernel_[u]long_t so that those struct types
> can be used with x32 system calls.

Independent on how this fixes things, how does the kernel_long_t name
here make any sense?

On x86-64 "kernel" long always is 64 bits wide.  The userspace ABI long
might be 32 or 64bits wide.

Currently kernel_long_t has almost no uses, so it might be a good time
to fix the name, define the rules for it, and last but not least
properly document the intent for thse types.

