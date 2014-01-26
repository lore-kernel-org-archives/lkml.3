Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaAZMet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 07:34:49 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:40415 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaAZMes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 07:34:48 -0500
MIME-Version: 1.0
In-Reply-To: <1390739073-4519-1-git-send-email-chris@chris-wilson.co.uk>
References: <1390316872-15887-1-git-send-email-chris@chris-wilson.co.uk>
	<1390739073-4519-1-git-send-email-chris@chris-wilson.co.uk>
Date: Sun, 26 Jan 2014 04:34:47 -0800
Message-ID: <CANN689G_vr0m_SJBb1C_QQBDAUK5n_EsXANpQaOg0W=inhMsZg@mail.gmail.com>
Subject: Re: [PATCH] lib: Export interval_tree
From: Michel Lespinasse <walken@google.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 4:24 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
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

Reviewed-by: Michel Lespinasse <walken@google.com>

Note for other reviewers, the lib/interval_tree_test.c is a straight
rename of the prior lib/interval_tree_test_main.c file.

> Note for maintainers, this is being proposed for use by i915.ko, so it
> may make the most sense to merge it via the drm/i915 tree in the next
> cycle.

Sounds fine to me, unless we get any other use cases before then.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
