Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbaDBAMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:12:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56340 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaDBAMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:12:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <533B55AE.9090906@jp.fujitsu.com>
Date: Wed, 02 Apr 2014 09:11:26 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        chenhanxiao <chenhanxiao@cn.fujitsu.com>,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net> <20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org> <1396306773.18499.22.camel@buesod1.americas.hpqcorp.net> <20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org> <1396308332.18499.25.camel@buesod1.americas.hpqcorp.net> <20140331170546.3b3e72f0.akpm@linux-foundation.org> <533A5CB1.1@jp.fujitsu.com> <20140401121920.50d1dd96c2145acc81561b82@linux-foundation.org> <CAHGf_=r03QWxw3Jg7BE3z37k4omgo_HRE9qCGw80ngtUD_iEeA@mail.gmail.com>
In-Reply-To: <CAHGf_=r03QWxw3Jg7BE3z37k4omgo_HRE9qCGw80ngtUD_iEeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/02 5:15), KOSAKI Motohiro wrote:
>>> Our middleware engineers has been complaining about this sysctl limit.
>>> System administrator need to calculate required sysctl value by making sum
>>> of all planned middlewares, and middleware provider needs to write "please
>>> calculate systcl param by....." in their installation manuals.
>>
>> Why aren't people just setting the sysctl to a petabyte?  What problems
>> would that lead to?
>
> I don't have much Fujitsu middleware knowledges. But I'd like to explain
> very funny bug I saw.
>
> 1. middleware-A suggest to set SHMMAX to very large value (maybe
> LONG_MAX, but my memory was flushed)
> 2. middleware-B suggest to set SHMMAX to increase some dozen mega byte.
>
> Finally, it was overflow and didn't work at all.
>
> Let's demonstrate.
>
> # echo 18446744073709551615 > /proc/sys/kernel/shmmax
> # cat /proc/sys/kernel/shmmax
> 18446744073709551615
> # echo 18446744073709551616 > /proc/sys/kernel/shmmax
> # cat /proc/sys/kernel/shmmax
> 0
>
> That's why many open source software continue the silly game. But
> again, I don't have knowledge about Fujitsu middleware. I'm waiting
> kamezawa-san's answer.
>

Nowadays, Middleware/application are required to be installed automatically without
any admin's operations. But the shmmax tends to be a value which admin needs to modify
by hand after installation. This is not the last one problem, but it is.

I says MW engineers "you, middleware/application, can modify it automatically
as you needed, there will be no pain".

But they tend not to do it. (in my guess) in application writer's way on thinking..
   - If there is a limit by OS, it should have some meaning.
     There may be an unknown, os internal reason which the system admin need to check it.
     For example, os will consume more resource when shmmax is enlarged.
   - If there is a limit by OS, it should be modified by admin.

I guess customer thinks so, too. There is no official information "increasing shmmax
will not cunsume any resource and will not cause any problem in the kernel inside."

Then, admins need to set it. Middleware needs to write "please modify the sysctl
value based on this calculation....." in their manual.

I think the worst problem about this "limit" is that it's hard to explain "why this limit
exists". I need to answer "I guess it's just legacy, hehe...."

Thanks,
-Kame

