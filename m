Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaAHCoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:44:38 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:53537 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaAHCo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:44:29 -0500
MIME-Version: 1.0
In-Reply-To: <52CC16DC.9070308@suse.cz>
References: <1387267550-8689-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<52b1138b.0201430a.19a8.605dSMTPIN_ADDED_BROKEN@mx.google.com>
	<52B11765.8030005@oracle.com>
	<52b120a5.a3b2440a.3acf.ffffd7c3SMTPIN_ADDED_BROKEN@mx.google.com>
	<52B166CF.6080300@suse.cz>
	<52b1699f.87293c0a.75d1.34d3SMTPIN_ADDED_BROKEN@mx.google.com>
	<20131218134316.977d5049209d9278e1dad225@linux-foundation.org>
	<52C71ACC.20603@oracle.com>
	<CA+55aFzDcFyyXwUUu5bLP3fsiuzxU7VPivpTPHgp8smvdTeESg@mail.gmail.com>
	<52C74972.6050909@suse.cz>
	<CA+55aFzq1iQqddGo-m=vutwMYn5CPf65Ergov5svKR4AWC3rUQ@mail.gmail.com>
	<6B2BA408B38BA1478B473C31C3D2074E2BF812BC82@SV-EXCHANGE1.Corp.FC.LOCAL>
	<52CC16DC.9070308@suse.cz>
Date: Wed, 8 Jan 2014 10:44:28 +0800
X-Google-Sender-Auth: scWf2pDOPj9hDPw8cnq4sIjbQ1M
Message-ID: <CA+55aFzCdGR+cNkvBiwmpgnOwFrVD+K9t4JJnFOL0FE-EtFMwQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear VMAs
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>, Bob Liu <bob.liu@oracle.com>,
        Nick Piggin <npiggin@suse.de>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 11:01 PM, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> So here's a patch that if accepted should replace the removal of BUG_ON patch in
> -mm tree: http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-bug_on-from-mlock_vma_page.patch
>
> The idea is that try_to_unmap_cluster() will try locking the page
> for mlock, and just leave it alone if lock cannot be obtained. Again
> that's not fatal, as eventually something will encounter and mlock the page.

This looks sane to me. Andrew?

            Linus
