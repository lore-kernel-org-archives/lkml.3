Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbbALMp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:45:26 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44068 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbALMpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:45:24 -0500
Message-ID: <54B3C1DD.6090400@hitachi.com>
Date: Mon, 12 Jan 2015 21:45:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Re: livepatching tree for linux-next
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz> <20141223094607.GA16445@infradead.org> <20141223151056.GA4789@treble.redhat.com> <20141226155613.36dd95b9@canb.auug.org.au> <20150107144317.61ab2080877a4d8227990551@linux-foundation.org> <alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz> <20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org> <alpine.LNX.2.00.1501080037030.15299@pobox.suse.cz> <20150107155701.4839545f63701412003edd88@linux-foundation.org> <alpine.LNX.2.00.1501080104190.15299@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1501080104190.15299@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/08 9:11), Jiri Kosina wrote:
> On Wed, 7 Jan 2015, Andrew Morton wrote:
> 
>>> --- a/kernel/livepatch/core.c
>>> +++ b/kernel/livepatch/core.c
>>> @@ -911,6 +911,12 @@ static int klp_init(void)
>>>  {
>>>  	int ret;
>>>  
>>> +	ret = klp_check_compiler_support();
>>> +	if (ret) {
>>> +		pr_info("Your compiler is too old; turning off.\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>
>> Looks reasonable.  
> 
> Thanks. Can I treat this as your Reported-and-tested-by .. ?
> 
>> It's a shame we've never figured out a way to do this at Kconfig-time.
> 
> That's something that has been on my TODO list for very long time (this is 
> not the first time I've been biten by that), but unfortunately rather low. 
> I will talk to Michal Marek to see whether he doesn't have any idea how to 
> implement this in an elegant way ... but let's keep that separate from 
> this thread.
> 
> In any case, Masami, I really think you would like to do something like 
> that for IPMODIFY as well ... or are you deliberately defering the 
> responsibility to handle the possible mcount fallout to the ftrace_ops 
> owner?

Ah, good point. I just tried to use ftrace and WARN if not possible
to use it. I'll see it tomorrow. Anyway, I'd prefer to have this
kind of checking functionality in ftrace.

Thank you,

>> That second #error doing in livepatch.h is a bit odd.  It errors out if 
>> anyone includes livepatch.h when CONFIG_LIVE_PATCHING=n.  Methinks it 
>> would be saner to change it to
>>
>> #error include linux/livepatch.h, not asm/livepatch.h
> 
> I guess that's a nice cleanup. Noted, thanks.
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


