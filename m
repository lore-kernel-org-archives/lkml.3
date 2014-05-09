Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbaEISTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907AbaEISTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:19:18 -0400
Message-ID: <536D1B6D.8060004@redhat.com>
Date: Fri, 09 May 2014 14:16:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com
Subject: Re: [PATCH] sched: wake up task on prev_cpu if not in SD_WAKE_AFFINE
 domain with cpu
References: <20140502004237.79dd3de6@annuminas.surriel.com>	 <1399011219.5233.55.camel@marge.simpson.net> <53633B81.1080403@redhat.com>	 <1399016273.5233.94.camel@marge.simpson.net> <536379D0.8070306@redhat.com>	 <1399030032.5233.142.camel@marge.simpson.net> <5363B793.9010208@redhat.com>	 <20140506115448.GH11096@twins.programming.kicks-ass.net>	 <536943C9.4030502@redhat.com>	 <20140506203916.GQ17778@laptop.programming.kicks-ass.net>	 <536C3B69.1000208@redhat.com>	 <20140509012743.67d4006d@annuminas.surriel.com>	 <1399620873.5200.68.camel@marge.simpson.net> <536CE48E.2060305@redhat.com>	 <1399649042.31219.47.camel@marge.simpson.net> <536CF346.6080009@redhat.com> <1399658123.5187.2.camel@marge.simpson.net>
In-Reply-To: <1399658123.5187.2.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 01:55 PM, Mike Galbraith wrote:
> On Fri, 2014-05-09 at 11:24 -0400, Rik van Riel wrote:
>> On 05/09/2014 11:24 AM, Mike Galbraith wrote:
>
>>> If no ->flags & SD_BALANCE_WAKE is encountered during traversal, sd
>>> remains NULL, we fall through to return prev_cpu.
>      ^^^^^^^^^^^^
>
>> We do fall through, but into this loop:
>
>>           while (sd) {

You are right. That code is a little hard to follow...

That leaves the big question: do we want to fall back to
prev_cpu if it is not idle, and it has an idle sibling,
or would it be better to find an idle sibling of prev_cpu
when we wake up a task?

