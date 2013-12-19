Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978Ab3LSFAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 00:00:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33771 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3LSFAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 00:00:04 -0500
Message-ID: <52B27D48.9030703@oracle.com>
Date: Wed, 18 Dec 2013 23:59:52 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>, Bob Liu <lliubbo@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mm/rmap: fix BUG at rmap_walk
References: <1387424720-22826-1-git-send-email-liwanp@linux.vnet.ibm.com> <CAA_GA1dA0Yohqx9=HRUJWWcbwp==n3uY5auuB-LRMHWtKJ3QBQ@mail.gmail.com> <20131219042902.GA27512@hacker.(null)>
In-Reply-To: <20131219042902.GA27512@hacker.(null)>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 11:29 PM, Wanpeng Li wrote:
>> PageLocked is not required by page_referenced_anon() and there is not
>> >any assertion before, commit 37f093cdf introduced this extra BUG_ON()
> There are two callsites shrink_active_list and page_check_references()
> of page_referenced(). shrink_active_list and its callee won't lock anonymous
> page, however, page_check_references() is called with anonymous page
> lock held in shrink_page_list. So page_check_references case need
> specail handling.

This explanation seems to be based on current observed behaviour.

I think it would be easier if you could point out the actual code in each
function that requires a page to be locked, once we have that we don't have
to care about what the callers currently do.


Thanks,
Sasha
