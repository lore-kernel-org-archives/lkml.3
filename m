Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaJ0QbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:31:01 -0400
Received: from nm13-vm9.access.bullet.mail.bf1.yahoo.com ([216.109.115.9]:47993
	"EHLO nm13-vm9.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbaJ0Qa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:30:59 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2014 12:30:58 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=yahoo.com;
	b=jDU3E1YGikQjDww4VvG/XfNhKmkXP/GTmBCYDTlzwX63mNUF8AIUY2Rgd4HOkgJGo7Qx41613RDpRo/tjiG/dfy/D9AvQI9VglfuGtJQZCfzKcU5b4TpiPR+4MQYzYx+Z+1Ll+u6pKWDY/OrfocKqc96qRRZyeTXCkoLVvBy3IQ43a4RnAIuyAYzD1GHwNC6wVMiYutajkO7qp51WTzgxeb5GiY2GqYH12T6vvvOIJlKXJxhajvEBvi5zMY7lNl9Vm9qo7Dp0JkRhv5ilRMIr+SNTjMjZw3eNCT/ETSiY+9LCsfzJ932IJ09s6vYAxmr0pIuc3YCheoFEKnmAkkWQQ==;
X-Yahoo-Newman-Id: 902433.89955.bm@smtp101.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qKh6KzsVM1kTdA4pM38qk6oMNYoAcdJfpKarZ8aCWjXMJEX
 iUwtYjR96PallvbJ_KKERMdIy7aGxUodjGSmJRkkgEyCdOVaQWtj_NR6Oqrv
 FVUiSlWhvTUXmV_3A5L1NRzbDbol7mwNulUZ5XcIgaWkdzj_gLT5B4v9b0gm
 s4TtJ0mnUCglUiMD5w8Sl_YB45b8dZ5Pga_DzNn_FH_3LLa_8CHpE1U11u5K
 qX0kiNyfPTdNpMvz.CWKneSn6KsG9n_3YNHXZ9yKAbPIaWvCk5J.ToTKj1lk
 UjdHwihERNi_gDDMz0BGbmRTpA3xJ7cLWnlTqnyGFv2yLNj.yHglWjPj0uUq
 L2jWdoJMkYTXmcIRzNEV8wlWyqptc9AOwNxNQTcNDrbbznfYZWSviuKAe1Qz
 l9NGznZ8jv_Bm5m8xySRg5w2gSR6kE35JaLrA6q4xp1..zmqlRKfkYZq6TSa
 gInxEMs_U_qfdJwxzTWcyteI65zMP9nhFIm4Mrdjuj1Spvn.GnuxVtx1YGAY
 zafS8jC5HYwC3c35A96_cCQfbxxu7_mqn4grD2CzswQVSGPwLjiteJMo1.2Z
 .RQLVGUw6FG355tPMixO.noZzwqRa.idsCJZyorf4w5XzdjVhEoVplOavoeH
 nk4FK3Y2nyCa8t0im
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <544E71F8.60301@schaufler-ca.com>
Date: Mon, 27 Oct 2014 09:25:28 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rohit <rohit.kr@samsung.com>
CC: PINTU KUMAR <pintu_agarwal@yahoo.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
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
        "me.rohit@live.com" <me.rohit@live.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v2] Security: smack: replace kzalloc with kmem_cache for
 inode_smack
References: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com> <543FF121.7000502@schaufler-ca.com> <20141017171229.7c1a113e@rohitk-ubuntu.sisodomain.com> <544129FD.8060902@schaufler-ca.com> <1413563667.96709.YahooMailNeo@web160104.mail.bf1.yahoo.com> <544153D1.50304@schaufler-ca.com> <544D94C1.8010402@schaufler-ca.com> <20141027122413.7edd8ee1@rohitk-ubuntu.sisodomain.com>
In-Reply-To: <20141027122413.7edd8ee1@rohitk-ubuntu.sisodomain.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2014 11:54 PM, Rohit wrote:
> On Sun, 26 Oct 2014 17:41:37 -0700
> Casey Schaufler <casey@schaufler-ca.com> wrote:
>
>> On 10/17/2014 10:37 AM, Casey Schaufler wrote:
>>> On 10/17/2014 9:34 AM, PINTU KUMAR wrote:
>>>> Hi,
>>>>
>>>>
>>>>> ________________________________
>>>>> From: Casey Schaufler <casey@schaufler-ca.com>
>>>>> To: Rohit <rohit.kr@samsung.com> 
>>>>> Cc: akpm@linux-foundation.org; james.l.morris@oracle.com;
>>>>> serge@hallyn.com; linux-security-module@vger.kernel.org;
>>>>> linux-kernel@vger.kernel.org; cpgs@samsung.com;
>>>>> pintu.k@samsung.com; vishnu.ps@samsung.com;
>>>>> iqbal.ams@samsung.com; ed.savinay@samsung.com; me.rohit@live.com;
>>>>> pintu_agarwal@yahoo.com; Casey Schaufler <casey@schaufler-ca.com>
>>>>> Sent: Friday, 17 October 2014 8:08 PM Subject: Re: [PATCH v2]
>>>>> Security: smack: replace kzalloc with kmem_cache for inode_smack
>>>>>
>>>>>
>>>>> On 10/17/2014 4:42 AM, Rohit wrote:
>>>>>> On Thu, 16 Oct 2014 09:24:01 -0700
>>>>>> Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>>>
>>>>>>> On 10/15/2014 5:10 AM, Rohit wrote:
>>>>>>>> The patch use kmem_cache to allocate/free inode_smack since
>>>>>>>> they are alloced in high volumes making it a perfect case for
>>>>>>>> kmem_cache.
>>>>>>>>
>>>>>>>> As per analysis, 24 bytes of memory is wasted per allocation
>>>>>>>> due to internal fragmentation. With kmem_cache, this can be
>>>>>>>> avoided.
>>>>>>> What impact does this have on performance? I am much more
>>>>>>> concerned with speed than with small amount of memory.
>>>>>>>
>>>>>> I think there should not be any performance problem as such.
>>>>>> However, please let me know how to check the performance in this
>>>>>> case.
>>>>> Any inode intensive benchmark would suffice. Even the classic
>>>>> kernel build would do.
>>>>>
>>>>>> As far as i know, kzalloc first finds the kmalloc_index
>>>>>> corresponding to the size to get the kmem_cache_object and then
>>>>>> calls kmem_cache_alloc with the kmalloc_index(kmem_cache
>>>>>> object). Here, we create kmem_cache object specific for
>>>>>> inode_smack and directly calls kmem_cache_alloc() which should
>>>>>> give better performance as compared to kzalloc.
>>>>> That would be my guess as well, but performance is tricky.
>>>>> Sometimes things that "obviously" make performance better make it
>>>>> worse. There can be unanticipated side effects.
>>>>>
>>>>>
>>>>>> Please let me know your comments.
>>>>> If you can run any sort of test that demonstrates this change
>>>>> does not have performance impact, I'm fine with it. Smack is being
>>>>> used in small devices, and both memory use and performance are
>>>>> critical to the success of these devices. Of the two, performance
>>>>> is currently more of an issue.
>>>>>
>>>> SMACK is used heavily in Tizen. We verified these changes for one
>>>> of Tizen project. During boot time we observed that this object is
>>>> used heavily, as identified by kmalloc-accounting. After replacing
>>>> this we did not observe any difference in boot time. Also there
>>>> was no side-effects seen so far. If you know of any other tests,
>>>> please let us know. We will also try to gather some performance
>>>> stats and present here.
>>> We need to be somewhat more precise than "did not observe any
>>> difference in boot time". The ideal benchmark would perform lots
>>> of changes to the filesystem without doing lots of IO. One process
>>> that matches that profile fairly well is a kernel make. I would be
>>> satisfied with something as crude as using time(1) on a small (5?)
>>> number of clean kernel makes each with and without the patch on the
>>> running kernel. At the level of accuracy you usually get from
>>> time(1) you won't find trivial differences, but if the change is a
>>> big problem (or a big win) we'll know.
>> I have not seen anything indicating that the requested performance
>> measurements have been done. I have no intention of accepting this
>> without assurance that performance has not been damaged. I request
>> that no one else carry this forward, either. The performance impact
>> of security facilities comes under too much scrutiny to ignore it.
>>
>>> ... 
> Sorry for the delay as I was on holiday for last week.
> Will verify the performance impact as per your suggestion.
> We verified it only on Tizen based ARM board, so building kernel on it
> is not possible.
> I found http://elinux.org/images/0/06/Buzov-SMACK.pdf (slides - 35-37)
> for performance verification of smack. It checks performance of file
> creation and copy in tmpfs. 
> Please let me know whether the procedure mentioned in the above
> mentioned slide is fine, else please suggest some other way to check
> performance on the target board.

The technique outlined by Buzov should provide adequate evidence.

>
>
> Regards,
> Rohit
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

