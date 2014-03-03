Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaCCSHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:07:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbaCCSHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:07:51 -0500
Message-ID: <5314C4C4.1020304@redhat.com>
Date: Mon, 03 Mar 2014 13:07:00 -0500
From: Joe Mario <jmario@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Don Zickus <dzickus@redhat.com>, Davidlohr Bueso <davidlohr@hp.com>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com> <1393609388-40489-9-git-send-email-dzickus@redhat.com> <87lhwvawc4.fsf@tassilo.jf.intel.com> <20140228194642.GM25953@redhat.com> <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net> <20140303150531.GZ25953@redhat.com> <20140303172316.GA22728@two.firstfloor.org>
In-Reply-To: <20140303172316.GA22728@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 12:23 PM, Andi Kleen wrote:
>> Hmm, so based on Andi's reply, I am assuming you are running on a Westmere
>> (or Nehalem) due to the lack of mem-stores.
>>
>> If you don't have mem-stores, this tool isn't going to work.  The tool can
>> only detect contention when sampling reads _and_ writes to the same
>> addresses.
>
> On these CPUs you could simply sample on HITM. You won't get addresses,
> but at least IPs and call stacks.
>
> -Andi
>

If you only sample on the HITMs then you don't get the store misses.  That means you'll not be able to detect who is simultaneously tugging on the same cache lines.  That gives up much of the value of "perf c2c".

As we developed this, we ended up settling on Ivy Bridge to get the behavior we wanted.

Joe
