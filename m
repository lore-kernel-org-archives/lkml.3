Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab3E1I4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:56:42 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55451 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933640Ab3E1I4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:56:39 -0400
Message-ID: <51A47126.7070501@linux.vnet.ibm.com>
Date: Tue, 28 May 2013 16:56:06 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v2] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <519AE7F2.706@linux.vnet.ibm.com> <20130522084947.GQ26912@twins.programming.kicks-ass.net> <519C8F24.5060207@linux.vnet.ibm.com> <1369234551.5916.40.camel@marge.simpson.net> <51A43A63.4090703@linux.vnet.ibm.com> <1369722552.5857.72.camel@marge.simpson.net> <51A45B23.4050403@linux.vnet.ibm.com> <1369730970.5857.132.camel@marge.simpson.net>
In-Reply-To: <1369730970.5857.132.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052808-5140-0000-0000-000003465FD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 04:49 PM, Mike Galbraith wrote:
> On Tue, 2013-05-28 at 15:22 +0800, Michael Wang wrote: 
>> On 05/28/2013 02:29 PM, Mike Galbraith wrote:
>>> On Tue, 2013-05-28 at 13:02 +0800, Michael Wang wrote: 
>>>> On 05/22/2013 10:55 PM, Mike Galbraith wrote:
>>>>> On Wed, 2013-05-22 at 17:25 +0800, Michael Wang wrote:
>>>>>
>>>>>> I've not test the hackbench with wakeup-buddy before, will do it this
>>>>>> time, I suppose the 15% illegal income will suffered, anyway, it's
>>>>>> illegal :)
>>>>>
>>>>> On a 4 socket 40 core (+SMT) box, hackbench wasn't too happy.
>>>>
>>>> I've done more test and now I got the reason of regression...
>>>>
>>>> The writer and reader in hackbench is N:N, prev writer will write all
>>>> the fd then switch to next writer and repeat the same work, so it's
>>>> impossible to setup the buddy relationship by just record the last one,
>>>> and we have to record all the waker/wakee in history, but that means
>>>> unacceptable memory overhead...
>>>
>>> Yeah, that's why I was thinking we'd need a dinky/fast as hell FIFO of
>>> tokens or such to bind waker/wakee more or less reliably.  Making such a
>>> scheme cheap enough could be hard.
>>>
>>>> So this buddy idea seems to be bad...
>>>>
>>>> I think a better way may should be allowing pull in most time, but
>>>> filter the very bad cases carefully.
>>>
>>> Any way that is cheap, and fairly accurately recognizes when we're being
>>> stupid will help.  First and foremost, it has to be dirt cheap :)
>>>
>>>> For workload like pgbench, we actually just need to avoid pull if that
>>>> will damage the 'mother' thread, which is busy and be relied by many
>>>> 'child'.
>>>
>>> Yeah, 'mom' is the key player.  If we can cheaply recognize mom, that
>>> should get us a generic improvement.  Not as good as being able to
>>> recognize the size of her+brood as size changes, but better anyway.
>>
>> That's right, I'm trying to rely on the frequency of a task switching
>> it's wakee in the new idea, it's really cheap and somewhat reliable, I
>> appreciate if you could pay an eye on the new patch and let me know you
>> opinion :)
> 
> I'll feed it to my 40 core box, hopefully soon.

Thanks for that, wish it taste delicious ;-)

Regards,
Michael Wang

> 
> -Mike
> 

