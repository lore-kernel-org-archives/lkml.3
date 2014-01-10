Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaAJHdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:33:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:38783 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbaAJHdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:33:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,637,1384329600"; 
   d="scan'208";a="456559377"
Message-ID: <52CFA22A.9060609@linux.intel.com>
Date: Fri, 10 Jan 2014 15:32:58 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Li, ZhenHua" <zhen-hual@hp.com>, Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/iommu: use bit structures for context_entry
References: <1387529101-29769-1-git-send-email-zhen-hual@hp.com> <20140107144108.GF2742@8bytes.org> <52CFA140.5060700@hp.com>
In-Reply-To: <52CFA140.5060700@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed the same issue too. But after second check, seems
it's safe with current implementation, but obviously it's not
future safe.

On 2014/1/10 15:29, Li, ZhenHua wrote:
> I have not seen such a bug yet . but obviously a '=' should be used when
> you want to set a value.
> 
> for example, if x != 0,
>     x=10
> and
>     x|=10
> will cause different result.
> 
> ZhenHua
> 
> On 01/07/2014 10:41 PM, Joerg Roedel wrote:
>> On Fri, Dec 20, 2013 at 04:45:01PM +0800, Li, Zhen-Hua wrote:
>>> There is a structure named context_entry used by intel iommu, and there
>>> are some bit operations on it. Use bit structure may make these
>>> operations
>>> easy.
>>> Also the function context_set_address_root may cause problem because
>>> it uses
>>>   |= operation, not set the new value. And this patch can fix it.
>>
>> What is the problem you are trying to fix here? Is it an actual bug?
>>
>>
>>     Joerg
>>
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
