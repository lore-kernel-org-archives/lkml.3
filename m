Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaAJH3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:29:18 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:1067 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaAJH3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:29:16 -0500
Message-ID: <52CFA140.5060700@hp.com>
Date: Fri, 10 Jan 2014 15:29:04 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/iommu: use bit structures for context_entry
References: <1387529101-29769-1-git-send-email-zhen-hual@hp.com> <20140107144108.GF2742@8bytes.org>
In-Reply-To: <20140107144108.GF2742@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have not seen such a bug yet . but obviously a '=' should be used when 
you want to set a value.

for example, if x != 0,
	x=10
and
	x|=10
will cause different result.

ZhenHua

On 01/07/2014 10:41 PM, Joerg Roedel wrote:
> On Fri, Dec 20, 2013 at 04:45:01PM +0800, Li, Zhen-Hua wrote:
>> There is a structure named context_entry used by intel iommu, and there
>> are some bit operations on it. Use bit structure may make these operations
>> easy.
>> Also the function context_set_address_root may cause problem because it uses
>>   |= operation, not set the new value. And this patch can fix it.
>
> What is the problem you are trying to fix here? Is it an actual bug?
>
>
> 	Joerg
>
>

