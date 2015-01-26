Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbbAZPZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:25:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbbAZPZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:25:28 -0500
Date: Mon, 26 Jan 2015 16:25:09 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill@shutemov.name, mhocko@suse.cz,
        mgorman@suse.de, rientjes@google.com, sasha.levin@oracle.com,
        hughd@google.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        riel@redhat.com
Subject: Re: [PATCH v2] mm: incorporate read-only pages into transparent huge
 pages
Message-ID: <20150126152509.GT11755@redhat.com>
References: <1422113880-4712-1-git-send-email-ebru.akagunduz@gmail.com>
 <54C5EE66.4060700@suse.cz>
 <20150126151906.GS11755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126151906.GS11755@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 04:19:06PM +0100, Andrea Arcangeli wrote:
> Overall I don't see how we could collapse in readonly vma and where
> the bug is for this case, but I may be overlooking something obvious.

I just realized what the problem was... that the "ro" is not the total
number of readonly ptes mapped by the pmd,.. because we don't count
the none ones as readonly too.

It misses a ro increase or equivalent adjustment:

		if (pte_none(pteval)) {
+			ro++;
			if (++none <= khugepaged_max_ptes_none)
[..]

Andrea
