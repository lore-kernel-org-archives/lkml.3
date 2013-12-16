Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3LPROu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:14:50 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39032 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab3LPROs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:14:48 -0500
Message-ID: <52AF3503.3010302@wwwdotorg.org>
Date: Mon, 16 Dec 2013 10:14:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>, Stephen Warren <swarren@nvidia.com>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6+ 01/13] of: introduce of_property_for_earch_phandle_with_args()
References: <20131211.153338.2186623380643957232.hdoyu@nvidia.com><20131212113417.BDCD0C40637@trevor.secretlab.ca><20131212.141404.684884000513445038.hdoyu@nvidia.com> <20131214.175115.1251935659998248370.hdoyu@nvidia.com>
In-Reply-To: <20131214.175115.1251935659998248370.hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 08:51 AM, Hiroshi Doyu wrote:
> Hiroshi Doyu <hdoyu@nvidia.com> wrote @ Thu, 12 Dec 2013 14:14:04 +0200 (EET):
> 
>>>> From 8f7c0404aa68f0e8dbe0babc240590f6528ecc1f Mon Sep 17 00:00:00 2001
>>>> From: Hiroshi Doyu <hdoyu@nvidia.com>
>>>> Date: Fri, 15 Nov 2013 10:52:53 +0200
>>>> Subject: [PATCH] of: introduce of_property_for_each_phandle_with_args()
>>>>
>>>> Iterating over a property containing a list of phandles with arguments
>>>> is a common operation for device drivers. This patch adds a new
>>>> of_property_for_each_phandle_with_args() macro to make the iteration
>>>> simpler.
>>>>
>>>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>>>> Cc: Rob Herring <robherring2@gmail.com>
> ....
>>>> ---
>>>>  drivers/of/base.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>  include/linux/of.h | 32 ++++++++++++++++++++++++++++++++
>>>>  2 files changed, 78 insertions(+)
>>>>
>>>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>>>> index f807d0e..cd4ab05 100644
>>>> --- a/drivers/of/base.c
>>>> +++ b/drivers/of/base.c
>>>> @@ -1201,6 +1201,52 @@ void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
>>>>       printk("\n");
>>>>  }
>>>>
>>>> +const __be32 *of_phandle_iter_next(const char *cells_name, int cell_count,
>>>> +                                const __be32 *cur, const __be32 *end,
>>>> +                                struct of_phandle_args *out_args)
>>>
>>> Having to pass in cells_name, cell_count, cur and end each time seems a
>>> little odd. Can a state structure be used instead?
>>>
>>> struct of_phandle_iter_state {
>>>         const char *cells_name;
>>>         int cells_count;
>>>         const __be32 *cur;
>>>         const __be32 *end;
>>>         struct of_phandle_args out_args;
>>> }
>>>
>>> Make the caller provide one of those and fill it in with the init
>>> function.
>>
>> I rewrote this a few times and so now I have a few version of this
>> implementations :-) The above proposal is similar to the version v6+++
>> mentioned in the above patch note:
>>
>>>> v6+++:
>>>> Introduced a new struct "of_phandle_iter" to keep the state when
>>>> iterating over the list.
>>
>> which is:
>>
>>   [RFC][PATCHv6+++ 01/13] of: introduce of_property_for_earch_phandle_with_args()
>>     http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007087.html
>>
>> Stephen seemed to prefer the version without state struct. I like the
>> idea to not pass the same arguments repeatly. Instead, wrapping them
>> in a struct with state may look better.
>>
>> So if Stephen agrees, I'll rewrite the version with state struct
>> again.
> 
> Stephen, let me know what you think.

It's hard to follow there have been so many revisions. As long as the
result is reasonable, I'll be OK with it. IIRC, I objected to using a
state structure for values that weren't needed by both functions, but if
both functions need the values, that's fine. I suppose even if they
don't both need the values, putting them in a state structure is OK too
if it means the patch gets finished!

