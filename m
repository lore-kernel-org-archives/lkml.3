Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaHOTbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:31:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaHOTbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:31:02 -0400
Date: Fri, 15 Aug 2014 21:30:43 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] gcc version 5: add basic definition header for latest
 gcc version
Message-ID: <20140815193043.GU1784@tucnak.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <1408130581-4806-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408130581-4806-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 03:23:01PM -0400, Paul Gortmaker wrote:
> --- /dev/null
> +++ b/include/linux/compiler-gcc5.h
> @@ -0,0 +1,52 @@
> +#ifndef __LINUX_COMPILER_H
> +#error "Please don't include <linux/compiler-gcc5.h> directly, include <linux/compiler.h> instead."
> +#endif
> +
> +#define __used			__attribute__((__used__))
> +#define __must_check		__attribute__((warn_unused_result))
> +#define __compiler_offsetof(a, b) __builtin_offsetof(a, b)
> +
> +/* Mark functions as cold. gcc will assume any path leading to a call
> +   to them will be unlikely.  This means a lot of manual unlikely()s
> +   are unnecessary now for any paths leading to the usual suspects
> +   like BUG(), printk(), panic() etc. [but let's keep them for now for
> +   older compilers]
> +
> +   Early snapshots of gcc 4.3 don't support this and we can't detect this
> +   in the preprocessor, but we can live with this because they're unreleased.
> +   Maketime probing would be overkill here.

The above 4 lines are probably unnecessary.

More importantly, is it a good idea to store the gcc major number in the
header?  gcc 5.x will be released next year, but the year after that we'll
have gcc 6.x, so you'd need to copy this header each year.

	Jakub
