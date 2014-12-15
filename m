Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaLOGlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:41:19 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63799 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaLOGlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:41:16 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-92-548e8287c1b3
Message-id: <548E8285.4060900@samsung.com>
Date: Mon, 15 Dec 2014 09:41:09 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadia.Derbey@bull.net, aquini@redhat.com,
        Joe Perches <joe@perches.com>, avagin@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH] kernel: sysctl: use 'unsigned long' type for 'zero'
 variable
References: <547F0486.7020400@samsung.com>
 <1417610481-11590-1-git-send-email-a.ryabinin@samsung.com>
 <20141203152524.4e2916fdbec5ebb16f1fe4d3@linux-foundation.org>
 <548CA6B6.3060901@colorfullife.com>
In-reply-to: <548CA6B6.3060901@colorfullife.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t/xy7rtTX0hBjdXGlrMWb+GzaJn904m
	ixkPf7FYrFh6jcVi9c01jBbPHz5kt5jwsI3dYvb9x0CJZ/eZLLY/e8tkcfP5HBaLlZ0PWC36
	H39nt7i8aw6bxb77U1gtPqw9xWJxom8tk0Xbko1MDkIeLxZuYfaY+HQmq8fL7RvYPHbOusvu
	sWBTqceeiSfZPE7M+M3iMe9koMekw5+ZPL6susbs8X7fVTaPqbPrPT5vkgvgjeKySUnNySxL
	LdK3S+DK+DrzNHvBOe6KRc8/MzcwfufoYuTkkBAwkThxdxYrhC0mceHeerYuRi4OIYGljBKr
	t/2AcpqZJBo7LzKCVPEKaEnM/tADlODgYBFQldjxMhEkzCagJ/Fv1nY2EFtUIELiw6qvbBDl
	ghI/Jt9jAbFFBIIlpn57BzaTWeAJi8S+l8vAZgoDJbYvaGSFWHaOUWLPrLlgHZwCBhIT2p4x
	gSxjBtpw/6IWSJhZQF5i85q3zBMYBWYh2TELoWoWkqoFjMyrGEVTS5MLipPScw31ihNzi0vz
	0vWS83M3MUKi88sOxsXHrA4xCnAwKvHwJuztDRFiTSwrrsw9xCjBwawkwtsd3xcixJuSWFmV
	WpQfX1Sak1p8iJGJg1OqgdGvYXLavT0PdpX6qDRtDGJkeSR1RT3wTdhxo+a1EpLycw0+VL38
	sqeLSbTsZbjVr4sfncpfpqQeEOS42iHy8ZACV8+t1b6FdhsXqE29+9ZI8VfP7r+Z69yubKy8
	xikct32b8lmBQLMfQk6bC3rWXW1/pXl3JsMNS5mEJ1O03/s+/io1+egkrmVKLMUZiYZazEXF
	iQA1OVZKrAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2014 11:51 PM, Manfred Spraul wrote:
> Hi,
> 
> On 12/04/2014 12:25 AM, Andrew Morton wrote:
>> On Wed, 03 Dec 2014 15:41:21 +0300 Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
>>
>>> Use the 'unsigned long' type for 'zero' variable to fix this.
>>> Changing type to 'unsigned long' shouldn't affect any other users
>>> of this variable.
>>>
>>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>>> Fixes: ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")
>>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
>>> ---
>>>   kernel/sysctl.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>>> index 15f2511..45c45c9 100644
>>> --- a/kernel/sysctl.c
>>> +++ b/kernel/sysctl.c
>>> @@ -120,7 +120,7 @@ static int sixty = 60;
>>>     static int __maybe_unused neg_one = -1;
>>>   -static int zero;
>>> +static unsigned long zero;
> 
> After some (useless) playing around (see the attached patch):
> 
> Using
>>    .extra1=zero,
> for proc_doulongvec_minmax doesn't make any sense:
> 
>  __do_proc_doulongvec_minmax() internally contains
>>                       if ((min && val < *min) || (max && val > *max))
>>                                 continue;
> 
> What about just deleting the offending .extra1=zero line?
> .extra1=NULL has the same effect as .extra1=&zero.
> 

Agreed, I think this should work.

> -- 
>     Manfred
> 
> 
> 

