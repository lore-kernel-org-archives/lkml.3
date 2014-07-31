Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbaGaJ3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:29:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49272 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbaGaJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:29:04 -0400
Message-ID: <53DA0C5A.3010409@codeaurora.org>
Date: Thu, 31 Jul 2014 14:58:58 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: BUG when __kmap_atomic_idx equals KM_TYPE_NR
References: <1406787871-2951-1-git-send-email-cpandya@codeaurora.org> <alpine.DEB.2.02.1407310001360.18238@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407310001360.18238@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 12:32 PM, David Rientjes wrote:
> On Thu, 31 Jul 2014, Chintan Pandya wrote:
>
>> __kmap_atomic_idx is per_cpu variable. Each CPU can
>> use KM_TYPE_NR entries from FIXMAP i.e. from 0 to
>> KM_TYPE_NR - 1. Allowing __kmap_atomic_idx to over-
>> shoot to KM_TYPE_NR can mess up with next CPU's 0th
>> entry which is a bug. Hence BUG_ON if
>> __kmap_atomic_idx>= KM_TYPE_NR.
>>
>
> This appears to be a completely different patch, not a v2.  Why is this
> check only done for CONFIG_DEBUG_HIGHMEM?

I agree that this check could have been there even without 
CONFIG_DEBUG_HIGHMEM for stability reasons.

>
> I think Andrew's comment earlier was referring to the changelog only and
> not the patch, which looked correct.

I think Andrew asked for a BUG case details also to justify the 
overhead. But we have never encountered that BUG case. Present patch is 
only logical fix to the code. However, in the fast path, if such 
overhead is allowed, I can move BUG_ON out of any debug configs. 
Otherwise, as per Andrew's suggestion, I will convert DEBUG_HIGHMEM into 
DEBUG_VM which is used more frequently.

>
>> Signed-off-by: Chintan Pandya<cpandya@codeaurora.org>
>> ---
>> Changes:
>>



-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
