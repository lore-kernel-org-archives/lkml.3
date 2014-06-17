Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaFQBAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 21:00:31 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57900 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaFQBA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 21:00:29 -0400
Date: Mon, 16 Jun 2014 17:59:07 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] hugetlb: fix copy_hugetlb_page_range() to handle
 migration/hwpoisoned entry
In-Reply-To: <20140616195950.GA21801@nhori.bos.redhat.com>
Message-ID: <alpine.LSU.2.11.1406161750520.1190@eggly.anvils>
References: <1402081620-1247-1-git-send-email-n-horiguchi@ah.jp.nec.com> <alpine.LSU.2.11.1406151642020.25482@eggly.anvils> <20140616195950.GA21801@nhori.bos.redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Naoya Horiguchi wrote:
> On Sun, Jun 15, 2014 at 05:19:29PM -0700, Hugh Dickins wrote:
> > 
> > Hold on, that restriction of hugepage migration was marked for stable
> > 3.12+, whereas this is marked for stable 2.6.36+ (a glance at my old
> > trees suggests 2.6.37+, but you may know better - perhaps hugepage
> > migration got backported to 2.6.36-stable, though hardly seems
> > stable material).
> 
> Sorry, I misinterpreted one thing.
> I thought hugepage migration was merged at 2.6.36 because git-describe
> shows v2.6.36-rc7-73-g290408d4a2 for commit 290408d4a2 "hugetlb: hugepage
> migration core." But actually that's merged at commit f1ebdd60cc, or
> v2.6.36-5792-gf1ebdd60cc73. So this is 2.6.37 stuff.
> 
> Originally hugepage migration was used only for soft offlining in
> mm/memory-failure.c which is available only in x86_64, so we implicitly
> assumed that hugepage migration was restricted to x86_64.
> At 3.12, hugepage migration became available for numa APIs like mbind(),
> which are used for other architectures, so the restriction with
> hugepage_migration_supported() became necessary since then.
> This is the reason why the disablement was marked for 3.12+.
> This patch are helpful before extension in 3.12, so it should be marked 2.6.37+.

That all makes sense to me now: thanks a lot for explaining the history.

Hugh
