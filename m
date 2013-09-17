Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3IQEOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:14:14 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50672 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab3IQEOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:14:11 -0400
Message-ID: <5237D710.2020301@gmail.com>
Date: Mon, 16 Sep 2013 22:14:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf session: Add option to copy events when queueing
References: <1378496221-61525-1-git-send-email-dsahern@gmail.com> <20130914161626.GD1718@localhost.localdomain> <52349C14.2070508@gmail.com> <20130916164022.GA29373@localhost.localdomain>
In-Reply-To: <20130916164022.GA29373@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/16/13 10:40 AM, Frederic Weisbecker wrote:
>> Yes. I could make it the default behavior; just overhead in doing
>> that (malloc/copy for each event).
>
> Are there any tool that don't suffer from this bug somehow? If not then it must
> be applied unconditionally.

I believe only 'live' commands would be affected: top, kvm stat live, my 
local scheduling daemon. perf-trace bypasses session and time ordering 
(though I question that decision).

---8<---

>> size of event is determined by mmap_event (mmap2_event in latest
>> code) which is > 4096 because of the filename argument. Including
>> the event directly in sample_queue would balloon memory usage
>> (learned this the hard way!).
>
> Ah then perhaps we can allocate with the dynamic size of the event?

Yes, that's how I have it my patch -- allocate memory based on header 
size and copy in the queue_event function. I think we agree on this part 
now.

---8<---

>>> Although the mirrored os->sample_buffer condition check is a bit ugly and should move to
>>> a function. But the idea is there.
>>
>> Ok. That should be a separate patch. Are you going to submit that one?
>
> Yeah, unless you beat me at it :)

That's not going to happen on my end due to a recent time constraint 
(jury duty - minimum 1 week trial). At best I can do a patch in early 
October.

David

