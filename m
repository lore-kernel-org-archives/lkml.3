Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaJaPqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:46:14 -0400
Received: from smtp107.biz.mail.bf1.yahoo.com ([98.139.244.55]:48376 "EHLO
	smtp107.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbaJaPqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:46:11 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2014 11:46:10 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ieryVbEVM1kfYcx2_rpj.DKXGgRP7t3rRMkxa7yjnED1nY2
 iZiVkFVLF_02pGlxXRTsDysefJ0CfxgEyfJq6jrSdqA6ua1I1cOfEW1JHn6r
 Nw86WWXP.PcGS_2f3hZkQZNtB_ZM404vu1niWReljKQ_pxS8EISRfVGYA4yX
 lI.71PzBQpUg7JM0FjzY6MkiM0YUTL6dqX9TdcY3oOxN14Bq5SrI60DD3F8c
 kv1PblLGLp5QxeKmWn76_z._Hc9PxJ4KlDovlLHn5.qX2ZcyQ2h7oRkjXmbm
 DDPtC.cgcbfloLtarEcumQqszPaLxvXYkS.PUW_DJSk2oWWhTaX1Sves1cNv
 aTK.OkkEGTu7law6sWX0wTPxrM2M0fxVWE8oZB5sftjORYNaF4FiCTL1NXbP
 Pgy7D9YPdvATBc2Qy6t3KMl8Okxi1TUX9x4L4DnxcSVP64bDPR50hWwFeL4Z
 7tJLJbEdovI0H.ammQqjQ0fdlzluTQpjbp2MBFlF9u0lgzoo6WxCbVwXIHuj
 Pn7NffJCpVKOKjv6k7NCGy1QsBxB1jiLntrGnwFRhkfNyYky9z.jv3gukheR
 kj_iA.onKO7Wec.IK_SzH6HM1i9Ii_vSuydL2Ullpn6qzjooyaQ8RTKY7miF
 TtwXHNhrmF32MlmJy
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <5453AD4A.10209@schaufler-ca.com>
Date: Fri, 31 Oct 2014 08:39:54 -0700
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
        "me.rohit@live.com" <me.rohit@live.com>
Subject: Re: [PATCH v2] Security: smack: replace kzalloc with kmem_cache for
 inode_smack
References: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com> <543FF121.7000502@schaufler-ca.com> <20141017171229.7c1a113e@rohitk-ubuntu.sisodomain.com> <544129FD.8060902@schaufler-ca.com> <1413563667.96709.YahooMailNeo@web160104.mail.bf1.yahoo.com> <544153D1.50304@schaufler-ca.com> <544D94C1.8010402@schaufler-ca.com> <20141027122413.7edd8ee1@rohitk-ubuntu.sisodomain.com> <544E71F8.60301@schaufler-ca.com> <20141029144134.46e16fb1@rohitk-ubuntu.sisodomain.com> <545103C5.3050509@schaufler-ca.com> <20141031093325.64808c2d@rohitk-ubuntu.sisodomain.com>
In-Reply-To: <20141031093325.64808c2d@rohitk-ubuntu.sisodomain.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 9:03 PM, Rohit wrote:
> On Wed, 29 Oct 2014 08:12:05 -0700
> Casey Schaufler <casey@schaufler-ca.com> wrote:
>
>> On 10/29/2014 2:11 AM, Rohit wrote:
>>> On Mon, 27 Oct 2014 09:25:28 -0700
>>> Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>
>>>> On 10/26/2014 11:54 PM, Rohit wrote:
>>>>> On Sun, 26 Oct 2014 17:41:37 -0700
>>>>> Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>>
>>>>>> On 10/17/2014 10:37 AM, Casey Schaufler wrote:
>>>>>>> On 10/17/2014 9:34 AM, PINTU KUMAR wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>>
>>>>>>>>> ________________________________
>>>>>>>>> From: Casey Schaufler <casey@schaufler-ca.com>
>>>>>>>>> To: Rohit <rohit.kr@samsung.com> 
>>>>>>>>> Cc: akpm@linux-foundation.org; james.l.morris@oracle.com;
>>>>>>>>> serge@hallyn.com; linux-security-module@vger.kernel.org;
>>>>>>>>> linux-kernel@vger.kernel.org; cpgs@samsung.com;
>>>>>>>>> pintu.k@samsung.com; vishnu.ps@samsung.com;
>>>>>>>>> iqbal.ams@samsung.com; ed.savinay@samsung.com;
>>>>>>>>> me.rohit@live.com; pintu_agarwal@yahoo.com; Casey Schaufler
>>>>>>>>> <casey@schaufler-ca.com> Sent: Friday, 17 October 2014 8:08 PM
>>>>>>>>> Subject: Re: [PATCH v2] Security: smack: replace kzalloc with
>>>>>>>>> kmem_cache for inode_smack
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 10/17/2014 4:42 AM, Rohit wrote:
>>>>>>>>>> On Thu, 16 Oct 2014 09:24:01 -0700
>>>>>>>>>> Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>>>>>>>
>>>>>>>>>>> On 10/15/2014 5:10 AM, Rohit wrote:
>>>>>>>>>>>> The patch use kmem_cache to allocate/free inode_smack since
>>>>>>>>>>>> they are alloced in high volumes making it a perfect case
>>>>>>>>>>>> for kmem_cache.
>>>>>>>>>>>>
>>>>>>>>>>>> As per analysis, 24 bytes of memory is wasted per
>>>>>>>>>>>> allocation due to internal fragmentation. With kmem_cache,
>>>>>>>>>>>> this can be avoided.
>>>>>>>>>>> What impact does this have on performance? I am much more
>>>>>>>>>>> concerned with speed than with small amount of memory.
>>>>>>>>>>>
>>>>>>>>>> I think there should not be any performance problem as such.
>>>>>>>>>> However, please let me know how to check the performance in
>>>>>>>>>> this case.
>>>>>>>>> Any inode intensive benchmark would suffice. Even the classic
>>>>>>>>> kernel build would do.
>>>>>>>>>
>>>>>>>>>> As far as i know, kzalloc first finds the kmalloc_index
>>>>>>>>>> corresponding to the size to get the kmem_cache_object and
>>>>>>>>>> then calls kmem_cache_alloc with the kmalloc_index(kmem_cache
>>>>>>>>>> object). Here, we create kmem_cache object specific for
>>>>>>>>>> inode_smack and directly calls kmem_cache_alloc() which
>>>>>>>>>> should give better performance as compared to kzalloc.
>>>>>>>>> That would be my guess as well, but performance is tricky.
>>>>>>>>> Sometimes things that "obviously" make performance better make
>>>>>>>>> it worse. There can be unanticipated side effects.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>> Please let me know your comments.
>>>>>>>>> If you can run any sort of test that demonstrates this change
>>>>>>>>> does not have performance impact, I'm fine with it. Smack is
>>>>>>>>> being used in small devices, and both memory use and
>>>>>>>>> performance are critical to the success of these devices. Of
>>>>>>>>> the two, performance is currently more of an issue.
>>>>>>>>>
>>>>>>>> SMACK is used heavily in Tizen. We verified these changes for
>>>>>>>> one of Tizen project. During boot time we observed that this
>>>>>>>> object is used heavily, as identified by kmalloc-accounting.
>>>>>>>> After replacing this we did not observe any difference in boot
>>>>>>>> time. Also there was no side-effects seen so far. If you know
>>>>>>>> of any other tests, please let us know. We will also try to
>>>>>>>> gather some performance stats and present here.
>>>>>>> We need to be somewhat more precise than "did not observe any
>>>>>>> difference in boot time". The ideal benchmark would perform lots
>>>>>>> of changes to the filesystem without doing lots of IO. One
>>>>>>> process that matches that profile fairly well is a kernel make.
>>>>>>> I would be satisfied with something as crude as using time(1)
>>>>>>> on a small (5?) number of clean kernel makes each with and
>>>>>>> without the patch on the running kernel. At the level of
>>>>>>> accuracy you usually get from time(1) you won't find trivial
>>>>>>> differences, but if the change is a big problem (or a big win)
>>>>>>> we'll know.
>>>>>> I have not seen anything indicating that the requested
>>>>>> performance measurements have been done. I have no intention of
>>>>>> accepting this without assurance that performance has not been
>>>>>> damaged. I request that no one else carry this forward, either.
>>>>>> The performance impact of security facilities comes under too
>>>>>> much scrutiny to ignore it.
>>>>>>
>>>>>>> ... 
>>>>> Sorry for the delay as I was on holiday for last week.
>>>>> Will verify the performance impact as per your suggestion.
>>>>> We verified it only on Tizen based ARM board, so building kernel
>>>>> on it is not possible.
>>>>> I found http://elinux.org/images/0/06/Buzov-SMACK.pdf (slides -
>>>>> 35-37) for performance verification of smack. It checks
>>>>> performance of file creation and copy in tmpfs. 
>>>>> Please let me know whether the procedure mentioned in the above
>>>>> mentioned slide is fine, else please suggest some other way to
>>>>> check performance on the target board.
>>>> The technique outlined by Buzov should provide adequate evidence.
>>> We carried out file creation of 0, 1k and 4k size for 1024 files
>>> and measured the time taken. It was done for 5 iterations for each
>>> case with kzalloc and kmem_cache on a board with 512MB RAM and 1.2
>>> GHz dual core arm processor. The average latency is as follows :
>>> File size   with kzalloc(in ms)   with kmem_cache(in ms)
>>> %change 0           10925.6               10528.8
>>> -3.63 1k           11909.8               11617.6
>>> -2.45 4k           11632.2               11873.2
>>> +2.07
>>>
>>> From the data, it seems that is no significant difference in
>>> performance. Please let me know your opinion.
>> The data is kind of scary, don't you think? The performance
>> starts out as an improvement, but gets worse as file size gets
>> bigger. This could be anomalous with your choice of file size.
>> We see that kzalloc performance improves going from 1k to 4k.
>>
>> Can you run the same test with 10 (20 would be better) iterations
>> for 0, 1k, 3k, 4k, 5k, 20k, 100k and 1m?
>>
>> I am curious now. I will run my own tests as well.
>>
> Yes, i too found it odd for 4k file taking less time than 1k size.
> Actually, issue was probably because I was using different block size
> for file creation in two cases.
>
> The latency for creating 1024 files with average of  10 iterations for
> below file size is as follows:
> File size   With Kzalloc(in ms)  With kmem_cache(in ms)     %change
> 0               10610.6              10595.4                 -0.14 
> 1k              11832.3              11667.4                 -1.39 
> 4k              11861.2              11802.1                 -0.49 
> 20k             11991.7              11977.7                 -0.11 
> 50k             12242.9              12224.7                 -0.14 
> 100k            12638.9              12581                   -0.45
>
> It seems kmem_cache has little better performance compared to kzalloc.
> Please share your comments and your test results,if any.

I got similar results with the kernel make tests. I will accept the patch.
Look for a message to that affect later today.

