Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaHDJZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:25:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48112 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaHDJZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:25:30 -0400
Message-ID: <53DF5184.1040501@codeaurora.org>
Date: Mon, 04 Aug 2014 14:55:24 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: BUG when __kmap_atomic_idx equals KM_TYPE_NR
References: <1406787871-2951-1-git-send-email-cpandya@codeaurora.org>	<alpine.DEB.2.02.1407310001360.18238@chino.kir.corp.google.com>	<53DA0C5A.3010409@codeaurora.org> <20140731154540.441ab79ff32ae5c10f64bcbd@linux-foundation.org>
In-Reply-To: <20140731154540.441ab79ff32ae5c10f64bcbd@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 04:15 AM, Andrew Morton wrote:
> On Thu, 31 Jul 2014 14:58:58 +0530 Chintan Pandya<cpandya@codeaurora.org>  wrote:
>
>>>
>>> I think Andrew's comment earlier was referring to the changelog only and
>>> not the patch, which looked correct.
>>
>> I think Andrew asked for a BUG case details also to justify the
>> overhead. But we have never encountered that BUG case. Present patch is
>> only logical fix to the code. However, in the fast path, if such
>> overhead is allowed, I can move BUG_ON out of any debug configs.
>> Otherwise, as per Andrew's suggestion, I will convert DEBUG_HIGHMEM into
>> DEBUG_VM which is used more frequently.
>
> The v1 patch added a small amount of overhead to kmap_atomic() for what
> is evidently a very small benefit.
>
> Yes, I suggest we remove CONFIG_DEBUG_HIGHMEM from the kernel entirely
> and switch all CONFIG_DEBUG_HIGHMEM sites to use CONFIG_DEBUG_VM.  That way
> the BUG_ON which you believe is useful will be tested by more people
> more often.

Ping!! Anything open for me to do here ?

-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
