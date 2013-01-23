Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3AWVpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 16:45:38 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:58000 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3AWVpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 16:45:33 -0500
MIME-Version: 1.0
In-Reply-To: <20130123131713.GG13304@suse.de>
References: <1358874762-19717-1-git-send-email-mgorman@suse.de>
 <1358874762-19717-6-git-send-email-mgorman@suse.de> <20130122144659.d512e05c.akpm@linux-foundation.org>
 <20130123131713.GG13304@suse.de>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 23 Jan 2013 16:45:12 -0500
Message-ID: <CAHGf_=qG+dUDbzgMxq5tsd5u5thmD4iYDGKmmyvSJt3-1va3vQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] mm: Fold page->_last_nid into page->flags where possible
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Good question.
>
> There are 19 free bits in my configuration but it's related to
> CONFIG_NODES_SHIFT which is 9 for me (512 nodes) and very heavily affected
> by options such as CONFIG_SPARSEMEM_VMEMMAP. Memory hot-remove does not work
> with CONFIG_SPARSEMEM_VMEMMAP and enterprise distribution configs may be
> taking the performance hit to enable memory hot-remove. If I disable this
> option to enable memory hot-remove then there are 0 free bits in page->flags.

FWIW, when using current mmotm, memory hot memory remove does work w/
CONFIG_SPARSEMEM_VMEMMAP. Recently Fujitsu changed.
