Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3AYCOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:14:35 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:57153 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab3AYCO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:14:29 -0500
Message-ID: <5101EA7B.4080405@linux.vnet.ibm.com>
Date: Fri, 25 Jan 2013 10:14:19 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <50FE5433.1070801@linux.vnet.ibm.com> <1358865692.5782.420.camel@marge.simpson.net> <50FF4EA0.1070000@linux.vnet.ibm.com> <1358915494.5752.46.camel@marge.simpson.net> <50FF7086.4020509@linux.vnet.ibm.com> <1358922520.5752.91.camel@marge.simpson.net> <50FF8CD8.4060105@linux.vnet.ibm.com>	 <1358929257.5752.109.camel@marge.simp! son.net>	 <50FF9F92.60202@linux.vnet.ibm.com> <1358930968.5752.123.camel@marge.simpson.net> <50FFA695.6010407@linux.vnet.ibm.com> <1358932694.5752.126.camel@marge.simpson.net> <1358933555.5752.132.camel@marge.simpson.net> <5100CE1F.7080704@linux.vnet.ibm.com> <1359010272.5833.39.camel@marge.simpson.net> <5100DF95.3020909@linux.vnet.ibm.com> <1359013623.5833.52.camel@marge.simpson.net> <5100ED7A.303@linux.vnet.ibm.com> <1359018455.5833.64.camel@marge.simpson.net> <5100FE61.1030004@linux.vnet.ibm.com> <1359023666.5833.105.camel@marge.simpson.net>
In-Reply-To: <1359023666.5833.105.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012502-9264-0000-0000-0000030F091B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 06:34 PM, Mike Galbraith wrote:
> On Thu, 2013-01-24 at 17:26 +0800, Michael Wang wrote: 
>> On 01/24/2013 05:07 PM, Mike Galbraith wrote:
>>> On Thu, 2013-01-24 at 16:14 +0800, Michael Wang wrote:
>>>
>>>> Now it's time to work on v3 I think, let's see what we could get this time.
>>>
>>> Maybe v3 can try to not waste so much ram on affine map?
>>
>> Yeah, that has been a question in my mind at very beginning, but how...
> 
> Allocate at domain build time the max we can acquire via hotplug?
>>> Even better would be if it could just go away, along with relic of the
>>> bad old days wake_affine(), and we make the balance path so damn light
>>> but clever that select_idle_sibling() can go away too... and a pony ;-)
>>
>> Hmm...may be, I need some consideration here, a totally balance path,
>> interesting...
> 
> Unification is the right target, hitting it might not be so easy though.
> 
>> But I think we still need the clean code which sbm bring to us, do we?
> 
> Sure, if it makes things perform better.

Ok, let me think about these, big changes may not show in v3, but I will
keep those in mind.

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

