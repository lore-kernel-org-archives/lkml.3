Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab3JNCXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 22:23:22 -0400
Received: from intranet.asianux.com ([58.214.24.6]:35068 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab3JNCXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 22:23:21 -0400
X-Spam-Score: -100.8
Message-ID: <525B555C.3040102@asianux.com>
Date: Mon, 14 Oct 2013 10:22:20 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] kernel/rcutorture.c: about using scnprintf() instead
 of sprintf().
References: <5253C335.5050609@asianux.com> <20131013110518.GC5790@linux.vnet.ibm.com> <525B4BB0.1090609@asianux.com>
In-Reply-To: <525B4BB0.1090609@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 09:41 AM, Chen Gang wrote:
> On 10/13/2013 07:05 PM, Paul E. McKenney wrote:
>> On Tue, Oct 08, 2013 at 04:32:53PM +0800, Chen Gang wrote:
>>> Hello Maintainers:
>>>
>>> In srcu_torture_stats(), if cpus are more than 1K, the PAGE_SIZE will
>>> not be enough.
>>>
>>> In rcu_torture_printk(), the 'page' maximized size is 4096, it has a
>>> function pointer for printing, which not tell its maximized length.
>>>
>>> Welcome any additional suggestions or completions.
>>
>> I never have run rcutorture on a system with that many CPUs.  ;-)
>>
> 
> I guess most of members (include me), never have run under that case.
> 
> 
>> Given that rcutorture is not used in production, my approach would be to
>> fix this when I encountered it.  But what change would you suggest, and,
>> more importantly, how would you go about testing it before submitting
>> a patch?
>>
> 
> OK, thanks, I will/should give a fix and test.
> 
> Hmm, In my opinion, we need:
> 
>  - let it pass LTP common simple test (so I can know how to test it).
> 

Oh, after read "Documentation/RCU/torture.txt", it is a test module, so
except related special test (e.g. shrink maximized buffer), it seems not
need additional common test for it (e.g. LTP).

>  - intend to shrink maximized buffer (PAGE_SIZE -> 64, 256 ..) for test.
> 
>  - read your original mail again (about testing contents) as reference.
> 
> Excuse me, I have to do some other things of company, so I will/should
> try to finish it within this week (2013-10-20), if this time point is
> not quite suitable, please let me know, thanks.
> 
> 
>> Or if you are simply reporting this as a bug, please let me know that.
>>
> 
> I will/should do: in q4 of 2013, I will/should spend part of my time
> resources on testing.
> 
> 
> 
> Welcome any additional suggestions or completions.
> 
> Thanks.
> 


-- 
Chen Gang
