Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbaGTDT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 23:19:27 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42850 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbaGTDT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 23:19:26 -0400
Message-ID: <53CB3537.5050806@hitachi.com>
Date: Sun, 20 Jul 2014 12:19:19 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH ftrace/core v3 2/3] ftrace, kprobes: Support IPMODIFY
 flag to find IP modify conflict
References: <20140715060015.12195.74457.stgit@kbuild-fedora.novalocal> <20140715060028.12195.33527.stgit@kbuild-fedora.novalocal> <20140717144110.0fb00723@gandalf.local.home> <53C8C813.2060709@hitachi.com> <20140718095132.34c9179e@gandalf.local.home>
In-Reply-To: <20140718095132.34c9179e@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/18 22:51), Steven Rostedt wrote:
> On Fri, 18 Jul 2014 16:09:07 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>>> "The ops can modify the IP register. This can only be set along with
>>> SAVE_REGS. If another ops is already registered for any of the
>>> functions that this ops will be registered for, then this ops will fail
>>> to register."
>>
>> Not only register, but also set_filter_ip ;)
>> "...will fail to register or set_filter_ip."
> 
> Sure.
> 
> 
>>>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>>>> index 3214289..e52d86f 100644
>>>> --- a/kernel/kprobes.c
>>>> +++ b/kernel/kprobes.c
>>>
>>> I think this should be split into two patches. One that adds the ftrace
>>> infrastructure, and the other that adds the kprobes user of the
>>> IPMODIFY flag.
>>
>> Hmm, I thought that it was natural to introduce new feature and its user
>> together, so that we could use git-bisect safely.
> 
> It should still be bisect friendly. That is, the feature is added
> before the user, not the user before the feature ;-)

Ah, I see.

> I know some people like the feature and user in one patch, but for me,
> when the user is in a different sub system (here it's kprobes) from the
> infrastructure that is changing (ftrace), I prefer separate patches.
> 
> The user patch shows me where the users are. When they are one patch, I
> tend to have them get lost.

OK, then I'll decouple it :)

Thanks!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


