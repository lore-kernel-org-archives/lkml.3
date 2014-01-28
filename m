Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaA1Lx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 06:53:26 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:53984 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaA1LxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 06:53:25 -0500
Date: Tue, 28 Jan 2014 13:53:16 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: readahead: fix do_readahead for no readpage(s)
Message-ID: <20140128115316.GA22934@node.dhcp.inet.fi>
References: <1390907659-11675-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390907659-11675-1-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 11:14:19AM +0000, Mark Rutland wrote:
> Commit 63d0f0a3c7e1 (mm/readahead.c:do_readhead(): don't check for
> ->readpage) unintentionally made do_readahead return 0 for all valid
> files regardless of whether readahead was supported, rather than the
> expected -EINVAL. This gets forwarded on to userspace, and results in
> sys_readahead appearing to succeed in cases that don't make sense (e.g.
> when called on pipes or sockets). This issue is detected by the LTP
> readahead01 testcase.
> 
> As the exact return value of force_page_cache_readahead is currently
> never used, we can simplify it to return only 0 or -EINVAL (when
> readpage or readpages is missing). With that in place we can simply
> forward on the return value of force_page_cache_readahead in
> do_readahead.
> 
> This patch performs said change, restoring the expected semantics.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
