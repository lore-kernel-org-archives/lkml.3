Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab3BEWUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:20:20 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34714 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757557Ab3BEWUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:20:17 -0500
Message-ID: <5111859B.7060004@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2013 14:20:11 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 6/9] mm/page_alloc: add informative debugging message
 in page_outside_zone_boundaries()
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com> <1358463181-17956-7-git-send-email-cody@linux.vnet.ibm.com> <20130201162848.74bdb2a7.akpm@linux-foundation.org> <20130201162957.3ec618cf.akpm@linux-foundation.org>
In-Reply-To: <20130201162957.3ec618cf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020522-9360-0000-0000-000010335783
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 04:29 PM, Andrew Morton wrote:
> On Fri, 1 Feb 2013 16:28:48 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>>> +	if (ret)
>>> +		pr_debug("page %lu outside zone [ %lu - %lu ]\n",
>>> +			pfn, start_pfn, start_pfn + sp);
>>> +
>>>   	return ret;
>>>   }
>>
>> As this condition leads to a VM_BUG_ON(), "pr_debug" seems rather wimpy
>> and I doubt if we need to be concerned about flooding the console.
>>
>> I'll switch it to pr_err.
>
> otoh, as nobody has ever hit that VM_BUG_ON() (yes?), do we really need
> the patch?

I've hit this bug while developing some code that moves pages between zones.

As it helped me debug that issue with my own code, I could see how 
another developer might be helped by it.

