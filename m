Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbaCaNhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:37:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821AbaCaNg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:36:59 -0400
Message-ID: <53396F4D.50402@redhat.com>
Date: Mon, 31 Mar 2014 09:36:13 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Add initcall_blacklist kernel parameter [v2]
References: <1396270321-20007-1-git-send-email-prarit@redhat.com> <20140331130417.GG22728@two.firstfloor.org>
In-Reply-To: <20140331130417.GG22728@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/31/2014 09:04 AM, Andi Kleen wrote:
>>  		do_initcall_level(level);
>> +
>> +	list_for_each_safe(tmp, next, &blacklisted_initcalls) {
>> +		entry = list_entry(tmp, struct blacklist_entry, next);
>> +		free_bootmem(entry->buf, strlen(entry->buf));
>> +		free_bootmem(entry, sizeof(*entry));
> 
> Does that really work? At this point the bootmem allocator should
> be already finished, so no memory will be freed.

Oh, geez ... that's a good point.  I completely missed that.

> 
> For this case it's probably ok to leak it.

Okay ... maybe that's an option.

> 
> Alternatively you could use static arrays and storing pointer/len.
> 

Yeah, I was thinking about the pros-cons of doing static vs. dynamic.  I was
planning on doing an array of 5 but kept falling into the trap of "how much is
too much or too little?".

Does anyone object to a static array?  If not I'll bang out a static version for
[v3] tomorrow ...

P.

> -Andi
> 
