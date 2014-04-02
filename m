Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbaDBBDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 21:03:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41318 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaDBBDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 21:03:19 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <533B61AC.7090808@jp.fujitsu.com>
Date: Wed, 02 Apr 2014 10:02:36 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        chenhanxiao <chenhanxiao@cn.fujitsu.com>,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>	<20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>	<1396306773.18499.22.camel@buesod1.americas.hpqcorp.net>	<20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>	<1396308332.18499.25.camel@buesod1.americas.hpqcorp.net>	<20140331170546.3b3e72f0.akpm@linux-foundation.org>	<533A5CB1.1@jp.fujitsu.com> <20140401121920.50d1dd96c2145acc81561b82@linux-foundation.org>
In-Reply-To: <20140401121920.50d1dd96c2145acc81561b82@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/02 4:19), Andrew Morton wrote:
> On Tue, 01 Apr 2014 15:29:05 +0900 Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>>>
>>> So their system will act as if they had set SHMMAX=enormous.  What
>>> problems could that cause?
>>>
>>>
>>> Look.  The 32M thing is causing problems.  Arbitrarily increasing the
>>> arbitrary 32M to an arbitrary 128M won't fix anything - we still have
>>> the problem.  Think bigger, please: how can we make this problem go
>>> away for ever?
>>>
>>
>> Our middleware engineers has been complaining about this sysctl limit.
>> System administrator need to calculate required sysctl value by making sum
>> of all planned middlewares, and middleware provider needs to write "please
>> calculate systcl param by....." in their installation manuals.
>
> Why aren't people just setting the sysctl to a petabyte?  What problems
> would that lead to?
>

They(and admin) don't know the fact, setting petabytes won't cause any pain.

In their thinking:
==
If there is a kernel's limit, it should have some (bad) side-effect and
the trade-off which must be handled by admin is represented by the limit.
In this case, they think setting this value large will consume tons of resource.
==
They don't care kernel's implemenation but takes care of what API says.

Of course, always I was asked, I answer set it to peta-bytes. But the fact
*default is small* makes them doubtful.

Thanks,
-Kame

