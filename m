Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbaITTVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 15:21:46 -0400
Received: from forward1l.mail.yandex.net ([84.201.143.144]:58577 "EHLO
	forward1l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaITTVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 15:21:45 -0400
X-Yandex-Uniq: 71fa70a3-f582-4065-8a74-ecc7ba65a2fb
Authentication-Results: smtp3h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <541DD3C5.9000904@yandex.ru>
Date: Sat, 20 Sep 2014 23:21:41 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Subject: Re: [PATCH 5/7] sched: Use rq->rd in sched_setaffinity() under RCU
 read lock
References: <20140920165116.16299.1381.stgit@localhost> <20140920165140.16299.45521.stgit@localhost> <20140920185901.GV2832@worktop.localdomain> <541DD00A.9010905@yandex.ru> <20140920191843.GX2832@worktop.localdomain>
In-Reply-To: <20140920191843.GX2832@worktop.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.09.2014 23:18, Peter Zijlstra wrote:
> On Sat, Sep 20, 2014 at 11:05:46PM +0400, Kirill Tkhai wrote:
>> On 20.09.2014 22:59, Peter Zijlstra wrote:
>>> On Sat, Sep 20, 2014 at 08:51:40PM +0400, Kirill Tkhai wrote:
>>>> From: Kirill Tkhai <ktkhai@parallels.com>
>>>>
>>>> task_rq(p)->rd and task_rq(p)->rd->span may be used-after-free here.
>>>> Probability of NULL pointer derefference isn't zero in this place.
>>>
>>> I don't see NULL derefs, just use-after-free.
>>>
>>
>> It's very paranod case :). Two pointers are here:
>>
>> task_rq(p)->rd (somebody zeroed it "rd") ->span
> 
> What you're saying is: due to the reuse someone might have put a NULL
> in there. Which is fair, but I'd still call it use-after-free because
> that is the first order problem. Dereferencing 'unknown' memory can of
> course cause all kinds of 'fun' problems :-)

Yeah, it's logical, I'll update the description.

