Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaACUwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:52:23 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56730 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaACUwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:52:22 -0500
MIME-Version: 1.0
In-Reply-To: <52C71ACC.20603@oracle.com>
References: <1387267550-8689-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<52b1138b.0201430a.19a8.605dSMTPIN_ADDED_BROKEN@mx.google.com>
	<52B11765.8030005@oracle.com>
	<52b120a5.a3b2440a.3acf.ffffd7c3SMTPIN_ADDED_BROKEN@mx.google.com>
	<52B166CF.6080300@suse.cz>
	<52b1699f.87293c0a.75d1.34d3SMTPIN_ADDED_BROKEN@mx.google.com>
	<20131218134316.977d5049209d9278e1dad225@linux-foundation.org>
	<52C71ACC.20603@oracle.com>
Date: Fri, 3 Jan 2014 12:52:21 -0800
X-Google-Sender-Auth: W8BGgBw5ZM44kwH7kY_kZey_RxU
Message-ID: <CA+55aFzDcFyyXwUUu5bLP3fsiuzxU7VPivpTPHgp8smvdTeESg@mail.gmail.com>
Subject: Re: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear VMAs
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michel Lespinasse <walken@google.com>, Bob Liu <bob.liu@oracle.com>,
        Nick Piggin <npiggin@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 12:17 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> Ping? This BUG() is triggerable in 3.13-rc6 right now.

So Andrew suggested just removing the BUG_ON(), but it's been there
for a *long* time.

And I detest the patch that was sent out that said "Should I check?"

Maybe we should just remove that mlock_vma_page() thing instead in
try_to_unmap_cluster()? Or maybe actually lock the page around calling
it?

             Linus
