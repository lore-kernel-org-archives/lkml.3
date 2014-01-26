Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaAZNyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 08:54:52 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:55082 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaAZNyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 08:54:51 -0500
Date: Sun, 26 Jan 2014 14:54:44 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [Intel-gfx] [PATCH] lib: Export interval_tree
Message-ID: <20140126135444.GR9772@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Rik van Riel <riel@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michel Lespinasse <walken@google.com>
References: <1390316872-15887-1-git-send-email-chris@chris-wilson.co.uk>
 <1390739073-4519-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390739073-4519-1-git-send-email-chris@chris-wilson.co.uk>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 12:24:33PM +0000, Chris Wilson wrote:
> lib/interval_tree.c provides a simple interface for an interval-tree
> (an augmented red-black tree) but is only built when testing the generic
> macros for building interval-trees. For drivers with modest needs,
> export the simple interval-tree library as is.
> 
> v2: Lots of help from Michel Lespinasse to only compile the code
>     as required:
>     - make INTERVAL_TREE a config option
>     - make INTERVAL_TREE_TEST select the library functions
>       and sanitize the filenames & Makefile
>     - prepare interval_tree for being built as a module if required
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---

[snip]

> diff --git a/lib/interval_tree.c b/lib/interval_tree.c
> index e6eb406f2d65..e4109f624e51 100644
> --- a/lib/interval_tree.c
> +++ b/lib/interval_tree.c
> @@ -1,6 +1,7 @@
>  #include <linux/init.h>
>  #include <linux/interval_tree.h>
>  #include <linux/interval_tree_generic.h>
> +#include <linux/module.h>
>  
>  #define START(node) ((node)->start)
>  #define LAST(node)  ((node)->last)
> @@ -8,3 +9,8 @@
>  INTERVAL_TREE_DEFINE(struct interval_tree_node, rb,
>  		     unsigned long, __subtree_last,
>  		     START, LAST,, interval_tree)
> +
> +EXPORT_SYMBOL(interval_tree_insert);
> +EXPORT_SYMBOL(interval_tree_remove);
> +EXPORT_SYMBOL(interval_tree_iter_first);
> +EXPORT_SYMBOL(interval_tree_iter_next);

Hm, I've thought kernel coding style nowadays is to put the EXPORT_SYMBOL
right below the definition of the function?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
