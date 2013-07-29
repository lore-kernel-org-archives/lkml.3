Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab3G2OY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:24:57 -0400
Received: from relay.parallels.com ([195.214.232.42]:45231 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3G2OY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:24:56 -0400
Message-ID: <51F67B27.9040004@parallels.com>
Date: Mon, 29 Jul 2013 18:24:39 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
References: <20130726201807.GJ8661@moon> <51F67777.6060609@parallels.com> <20130729141417.GM2524@moon>
In-Reply-To: <20130729141417.GM2524@moon>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 06:14 PM, Cyrill Gorcunov wrote:
> On Mon, Jul 29, 2013 at 06:08:55PM +0400, Pavel Emelyanov wrote:
>>>  
>>> -	if (!pte_none(*pte))
>>> +	ptfile = pgoff_to_pte(pgoff);
>>> +
>>> +	if (!pte_none(*pte)) {
>>> +#ifdef CONFIG_MEM_SOFT_DIRTY
>>> +		if (pte_present(*pte) &&
>>> +		    pte_soft_dirty(*pte))
>>
>> I think there's no need in wrapping every such if () inside #ifdef CONFIG_...,
>> since the pte_soft_dirty() routine itself would be 0 for non-soft-dirty case
>> and compiler would optimize this code out.
> 
> If only I'm not missing something obvious, this code compiles not only on x86,
> CONFIG_MEM_SOFT_DIRTY depends on x86 (otherwise I'll have to implement
> pte_soft_dirty for all archs).

For non-x86 case there are stubs in include/asm-generic/pgtable.h that would
act as if the CONFIG_MEM_SOFT_DIRTY is off.

Thanks,
Pavel
