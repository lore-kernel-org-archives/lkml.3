Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3LZKDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 05:03:53 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3LZKDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 05:03:51 -0500
Date: Thu, 26 Dec 2013 02:03:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_long_t/__kernel_ulong_t in
 <linux/resource.h>
Message-ID: <20131226100348.GA7751@infradead.org>
References: <20131225145447.GA18146@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131225145447.GA18146@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 25, 2013 at 06:54:47AM -0800, H.J. Lu wrote:
> Both x32 and x86-64 use the same struct rusage and struct rlimit for
> system calls.  But x32 log is 32-bit.  This patch change uapi
> <linux/resource.h> to use __kernel_long_t in struct rusage and
> __kernel_ulong_t in and struct rlimit.

 a) please send all your related patches as a series
 b) explain how these changes to shared ABI headers:

     1) do not break any architecture, especially mips N32 which is
        the MIPS equivalent of x32
     2) do not break existing x32 binaries
     3) fix existing and future x32 binaries

 c) why you suddenly need these changes now and not when the x32 ABI
    support was submitted and hopefully heavily tested
