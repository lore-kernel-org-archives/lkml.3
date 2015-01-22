Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbbAVPiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:38:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbbAVPio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:38:44 -0500
Message-ID: <54C11982.9070802@suse.cz>
Date: Thu, 22 Jan 2015 16:38:42 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Vinayak Menon <vinmenon@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mgorman@suse.de, minchan@kernel.org, iamjoonsoo.kim@lge.com
Subject: Re: [PATCH] mm: compaction: fix the page state calculation in too_many_isolated
References: <1421832864-30643-1-git-send-email-vinmenon@codeaurora.org> <54BF78E3.7030303@suse.cz> <alpine.DEB.2.10.1501211656160.28120@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.10.1501211656160.28120@chino.kir.corp.google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 01:58 AM, David Rientjes wrote:
>> I think in case of async compaction, we could skip the safe stuff and just
>> terminate it - it's already done when too_many_isolated returns true, and
>> there's no congestion waiting in that case.
>>
>> So you could extend the too_many_isolated() with "safe" parameter (as you did
>> for vmscan) and pass it "cc->mode != MIGRATE_ASYNC" value from
>> isolate_migrate_block().
>>
>
> Or just pass it struct compact_control *cc and use both cc->zone and
> cc->mode inside this compaction-only function.

Yeah,

in any case, please wait until the discussion about the vmscan fix is 
resolved, before reposting this.

Thanks.

