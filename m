Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaFKLdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:33:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310AbaFKLdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:33:35 -0400
Message-ID: <53983E8C.80207@suse.cz>
Date: Wed, 11 Jun 2014 13:33:32 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 05/10] mm, compaction: remember position within pageblock
 in free pages scanner
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz> <1402305982-6928-5-git-send-email-vbabka@suse.cz> <20140611021213.GF15630@bbox>
In-Reply-To: <20140611021213.GF15630@bbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 04:12 AM, Minchan Kim wrote:
>> >@@ -314,6 +315,9 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>> >  		int isolated, i;
>> >  		struct page *page = cursor;
>> >
>> >+		/* Record how far we have got within the block */
>> >+		*start_pfn = blockpfn;
>> >+
> Couldn't we move this out of the loop for just one store?

You mean using a local variable inside the loop, and assigning once, for 
performance reasons (register vs memory access)?
