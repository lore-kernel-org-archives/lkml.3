Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaJ0AlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:41:16 -0400
Received: from smtp103.biz.mail.bf1.yahoo.com ([98.139.221.62]:41231 "EHLO
	smtp103.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbaJ0AlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:41:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UtuifpMVM1nQjWAo81iqH5SGbOUD8RORQmTmoKXBnToPAoo
 UNaA3XezdbZS1wzD3qs.OyTy.4FGBUN7CXOo1d.YUwH2qKnL5w.0wPCR14af
 UL0a8q_dFWX4qwZAmzyzrad69IQixMzh3caIuRjWFreEqRIEIUGFziIjk7Fq
 hJOglpwomrHCkIxKyzW3ZOJ8h76M0xr3puryFbE_Z5plVNC4tXLMzQHo17pJ
 Pb0EsAwGuFD9eFBGMsfZ.XdfzWANCwWazASITbOfiHZxbS6QCjikSeGuh.P7
 y_DMUmKZUsetJlgmFf8_e5rFyYHhae75ruS.P0FPXB51As0JJG2aeydZubbP
 qR5AKjKb_qLt.qoP.Kcl62qvq6_x1Yvuz6RCsaGKsg1sFhm5n9nTFBlC5oC8
 hXVz30Ijns5_JIBHvNZra4oUu5H8C4hWltt4iRmiVwJcz9wfbBTbrQwYyT6A
 n308ZMrbiox9l3PhV6UGHTG6aHfUKMkz9GNf7fO_iPlP.RqRNpQg9LETIY5u
 qReWlvFJ36iFG2VQbWcajhQDUMlqe6MKbkccmfWuky2M1
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <544D94C1.8010402@schaufler-ca.com>
Date: Sun, 26 Oct 2014 17:41:37 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: PINTU KUMAR <pintu_agarwal@yahoo.com>, Rohit <rohit.kr@samsung.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "james.l.morris@oracle.com" <james.l.morris@oracle.com>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        "iqbal.ams@samsung.com" <iqbal.ams@samsung.com>,
        "ed.savinay@samsung.com" <ed.savinay@samsung.com>,
        "me.rohit@live.com" <me.rohit@live.com>
Subject: Re: [PATCH v2] Security: smack: replace kzalloc with kmem_cache for
 inode_smack
References: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com> <543FF121.7000502@schaufler-ca.com> <20141017171229.7c1a113e@rohitk-ubuntu.sisodomain.com> <544129FD.8060902@schaufler-ca.com> <1413563667.96709.YahooMailNeo@web160104.mail.bf1.yahoo.com> <544153D1.50304@schaufler-ca.com>
In-Reply-To: <544153D1.50304@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2014 10:37 AM, Casey Schaufler wrote:
> On 10/17/2014 9:34 AM, PINTU KUMAR wrote:
>> Hi,
>>
>>
>>> ________________________________
>>> From: Casey Schaufler <casey@schaufler-ca.com>
>>> To: Rohit <rohit.kr@samsung.com> 
>>> Cc: akpm@linux-foundation.org; james.l.morris@oracle.com; serge@hallyn.com; linux-security-module@vger.kernel.org; linux-kernel@vger.kernel.org; cpgs@samsung.com; pintu.k@samsung.com; vishnu.ps@samsung.com; iqbal.ams@samsung.com; ed.savinay@samsung.com; me.rohit@live.com; pintu_agarwal@yahoo.com; Casey Schaufler <casey@schaufler-ca.com> 
>>> Sent: Friday, 17 October 2014 8:08 PM
>>> Subject: Re: [PATCH v2] Security: smack: replace kzalloc with kmem_cache for inode_smack
>>>
>>>
>>> On 10/17/2014 4:42 AM, Rohit wrote:
>>>> On Thu, 16 Oct 2014 09:24:01 -0700
>>>> Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>
>>>>> On 10/15/2014 5:10 AM, Rohit wrote:
>>>>>> The patch use kmem_cache to allocate/free inode_smack since they are
>>>>>> alloced in high volumes making it a perfect case for kmem_cache.
>>>>>>
>>>>>> As per analysis, 24 bytes of memory is wasted per allocation due
>>>>>> to internal fragmentation. With kmem_cache, this can be avoided.
>>>>> What impact does this have on performance? I am much more
>>>>> concerned with speed than with small amount of memory.
>>>>>
>>>> I think there should not be any performance problem as such.
>>>> However, please let me know how to check the performance in this case.
>>> Any inode intensive benchmark would suffice. Even the classic
>>> kernel build would do.
>>>
>>>> As far as i know, kzalloc first finds the kmalloc_index corresponding to
>>>> the size to get the kmem_cache_object and then calls kmem_cache_alloc
>>>> with the kmalloc_index(kmem_cache object). Here, we create kmem_cache
>>>> object specific for inode_smack and directly calls kmem_cache_alloc()
>>>> which should give better performance as compared to kzalloc.
>>> That would be my guess as well, but performance is tricky. Sometimes
>>> things that "obviously" make performance better make it worse. There can
>>> be unanticipated side effects.
>>>
>>>
>>>> Please let me know your comments.
>>> If you can run any sort of test that demonstrates this change
>>> does not have performance impact, I'm fine with it. Smack is being
>>> used in small devices, and both memory use and performance are critical
>>> to the success of these devices. Of the two, performance is currently
>>> more of an issue.
>>>
>> SMACK is used heavily in Tizen. We verified these changes for one of Tizen project.
>> During boot time we observed that this object is used heavily, as identified by kmalloc-accounting.
>> After replacing this we did not observe any difference in boot time. Also there was no side-effects seen so far.
>> If you know of any other tests, please let us know.
>> We will also try to gather some performance stats and present here.
> We need to be somewhat more precise than "did not observe any
> difference in boot time". The ideal benchmark would perform lots
> of changes to the filesystem without doing lots of IO. One process
> that matches that profile fairly well is a kernel make. I would be
> satisfied with something as crude as using time(1) on a small (5?)
> number of clean kernel makes each with and without the patch on the
> running kernel. At the level of accuracy you usually get from time(1)
> you won't find trivial differences, but if the change is a big problem
> (or a big win) we'll know.

I have not seen anything indicating that the requested performance
measurements have been done. I have no intention of accepting this
without assurance that performance has not been damaged. I request
that no one else carry this forward, either. The performance impact
of security facilities comes under too much scrutiny to ignore it.

> ... 

