Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3KUTAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:00:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35513 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3KUTAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:00:21 -0500
Message-ID: <528E566E.1020704@wwwdotorg.org>
Date: Thu, 21 Nov 2013 11:52:30 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
CC: Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 1/9] of: introduce of_property_for_earch_phandle_with_args()
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com><20131121151218.befbb483c0cf09cdcd4cd4dd@nvidia.com><20131121155649.48C96C406A3@trevor.secretlab.ca> <20131121.192051.747601347584525020.hdoyu@nvidia.com>
In-Reply-To: <20131121.192051.747601347584525020.hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 10:20 AM, Hiroshi Doyu wrote:
> Grant Likely <grant.likely@linaro.org> wrote @ Thu, 21 Nov 2013 16:56:49 +0100:
> 
>> On Thu, 21 Nov 2013 15:12:18 +0200, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
>>> On Thu, 21 Nov 2013 13:43:28 +0100
>>> Grant Likely <grant.likely@linaro.org> wrote:
>>>
>>>> On Tue, 19 Nov 2013 11:33:05 +0200, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
>>>>> The following pattern of code is tempting:
>>>>>
>>>>>   for (i = 0; !of_parse_phandle_with_args(np, list, cells, i, args); i++)
>>>>>
>>>>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>>>>
>>>> That's a very minimal commit message. Can you elaborate please.
>>>
>>> The above can be:
>>>
>>> "
>>>   The following pattern of code is tempting to add a new member for
>>>   of_property_for_each_*() family as an idiom.
>>>   
>>>     for (i = 0;
>>>         !of_parse_phandle_with_args(np, list, cells, i, args); i++)
>>>                   <do something with "args">;
>>> "
>>
>> I really do like commit messages to be full enough that a future reader
>> can figure out why a patch was written. ie:
> 
> Updated as:
> 
>   [PATCHv6+ 01/13] of: introduce of_property_for_earch_phandle_with_args()
>     http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007063.html
> 
> This doesn't depend on anything and this can be merged
> independetly. Thanks for your help.

Well, that patch doesn't depend /on/ anything, but something in the rest
of the series does depend /on it/. As such, this patch can't be merged
completely independently; it has to either:

a) Go into whatever branch the rest of the series goes into.

b) Go into a topic branch in the DT tree, which is then both merged into
the main/regular DT tree /and/ used as a base for the rest of this series.

Dependencies work two ways!

(That is, unless this 1 patch gets merged into 3.14, and the rest of
series doesn't get merged until 3.15. In that case, we can ignore the
dependencies).
