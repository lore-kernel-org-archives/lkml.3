Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3L0WTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:19:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51217 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab3L0WTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:19:53 -0500
Message-ID: <52BDFD00.7020909@oracle.com>
Date: Fri, 27 Dec 2013 17:19:44 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: dump page when hitting a VM_BUG_ON using VM_BUG_ON_PAGE
References: <1388114452-30769-1-git-send-email-sasha.levin@oracle.com> <20131227103847.GA19453@node.dhcp.inet.fi>
In-Reply-To: <20131227103847.GA19453@node.dhcp.inet.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2013 05:38 AM, Kirill A. Shutemov wrote:
> On Thu, Dec 26, 2013 at 10:20:52PM -0500, Sasha Levin wrote:
>> Most of the VM_BUG_ON assertions are performed on a page. Usually, when
>> one of these assertions fails we'll get a BUG_ON with a call stack and
>> the registers.
>>
>> I've recently noticed based on the requests to add a small piece of code
>> that dumps the page to various VM_BUG_ON sites that the page dump is quite
>> useful to people debugging issues in mm.
>>
>> This patch adds a VM_BUG_ON_PAGE(cond, page) which beyond doing what
>> VM_BUG_ON() does, also dumps the page before executing the actual BUG_ON.
>>
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>
> I like the idea. One thing I've noticed you have a lot of page flag based
> asserts, like:
>
> 	VM_BUG_ON_PAGE(PageLRU(page), page);
> 	VM_BUG_ON_PAGE(!PageLocked(page), page);
>
> What about adding per-page-flag assert macros, like:
>
> 	PageNotLRU_assert(page);
> 	PageLocked_assert(page);
>
> ? This way we will always dump right page on bug.
>

Sure, sounds good.

I'll send another patch on top of this one.


Thanks,
Sasha
