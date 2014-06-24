Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaFXPoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:44:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbaFXPoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:44:15 -0400
Message-ID: <53A99CCD.5050103@suse.cz>
Date: Tue, 24 Jun 2014 17:44:13 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/13] mm, compaction: periodically drop lock and restore
 IRQs in scanners
References: <1403279383-5862-1-git-send-email-vbabka@suse.cz> <1403279383-5862-7-git-send-email-vbabka@suse.cz> <20140624153900.GB18289@nhori.bos.redhat.com>
In-Reply-To: <20140624153900.GB18289@nhori.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 05:39 PM, Naoya Horiguchi wrote:
> On Fri, Jun 20, 2014 at 05:49:36PM +0200, Vlastimil Babka wrote:
>> Compaction scanners regularly check for lock contention and need_resched()
>> through the compact_checklock_irqsave() function. However, if there is no
>> contention, the lock can be held and IRQ disabled for potentially long time.
>>
>> This has been addressed by commit b2eef8c0d0 ("mm: compaction: minimise the
>> time IRQs are disabled while isolating pages for migration") for the migration
>> scanner. However, the refactoring done by commit 748446bb6b ("mm: compaction:
>> acquire the zone->lru_lock as late as possible") has changed the conditions so
>
> You seem to refer to the incorrect commit, maybe you meant commit 2a1402aa044b?

Oops, right. Thanks!

