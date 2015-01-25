Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbbAYJZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 04:25:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbbAYJZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 04:25:25 -0500
Message-ID: <54C4B680.3010304@suse.cz>
Date: Sun, 25 Jan 2015 10:25:20 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>
CC: linux-mm@kvack.org, akpm@linux-foundation.org, kirill@shutemov.name,
        mhocko@suse.cz, mgorman@suse.de, rientjes@google.com,
        sasha.levin@oracle.com, hughd@google.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH] mm: incorporate read-only pages into transparent huge
 pages
References: <1421999256-3881-1-git-send-email-ebru.akagunduz@gmail.com> <20150123191816.GN11755@redhat.com>
In-Reply-To: <20150123191816.GN11755@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.1.2015 20:18, Andrea Arcangeli wrote:
>> >+		if (!pte_write(pteval)) {
>> >+			if (++ro > khugepaged_max_ptes_none)
>> >+				goto out_unmap;
>> >+		}
> It's true this is maxed out at 511, so there must be at least one
> writable and not none pte (as results of the two "ro" and "none"
> counters checks).

Hm, but if we consider ro and pte_none separately, both can be lower
than 512, but the sum of the two can be 512, so we can actually be in
read-only VMA?
