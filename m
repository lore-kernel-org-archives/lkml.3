Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaADDcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 22:32:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29491 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaADDcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 22:32:21 -0500
Message-ID: <52C780A3.8030405@oracle.com>
Date: Sat, 04 Jan 2014 11:31:47 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michel Lespinasse <walken@google.com>, Nick Piggin <npiggin@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear VMAs
References: <1387267550-8689-1-git-send-email-liwanp@linux.vnet.ibm.com> <52b1138b.0201430a.19a8.605dSMTPIN_ADDED_BROKEN@mx.google.com> <52B11765.8030005@oracle.com> <52b120a5.a3b2440a.3acf.ffffd7c3SMTPIN_ADDED_BROKEN@mx.google.com> <52B166CF.6080300@suse.cz> <52b1699f.87293c0a.75d1.34d3SMTPIN_ADDED_BROKEN@mx.google.com> <20131218134316.977d5049209d9278e1dad225@linux-foundation.org> <52C71ACC.20603@oracle.com> <CA+55aFzDcFyyXwUUu5bLP3fsiuzxU7VPivpTPHgp8smvdTeESg@mail.gmail.com>
In-Reply-To: <CA+55aFzDcFyyXwUUu5bLP3fsiuzxU7VPivpTPHgp8smvdTeESg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/04/2014 04:52 AM, Linus Torvalds wrote:
> On Fri, Jan 3, 2014 at 12:17 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> Ping? This BUG() is triggerable in 3.13-rc6 right now.
> 
> So Andrew suggested just removing the BUG_ON(), but it's been there
> for a *long* time.
> 
> And I detest the patch that was sent out that said "Should I check?"
> 
> Maybe we should just remove that mlock_vma_page() thing instead in
> try_to_unmap_cluster()? Or maybe actually lock the page around calling

I didn't get the reason why we have to call mlock_vma_page() in
try_to_unmap_cluster() and I agree to just remove it.

> it?
> 
>              Linus
> 

-- 
Regards,
-Bob
