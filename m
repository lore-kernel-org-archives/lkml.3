Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab3KFKfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:35:23 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58957 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3KFKfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:35:10 -0500
Message-ID: <527A1B50.6080408@hitachi.com>
Date: Wed, 06 Nov 2013 19:34:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VXdlIEtsZQ==?= =?UTF-8?B?aW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip v2 3/3] [BUGFIX] kprobes: Prohibit probing on func_ptr_is_kernel_text
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal> <20131101112537.14657.88496.stgit@kbuild-fedora.novalocal> <20131104210053.76c37210@gandalf.local.home> <20131105060901.GA29936@gmail.com> <5278973A.1010705@hitachi.com> <20131105070537.GA2007@gmail.com> <5278D89B.1070806@hitachi.com> <20131106060737.GC24044@gmail.com>
In-Reply-To: <20131106060737.GC24044@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/06 15:07), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>>>> [...] I hope to build the list when the kernel build time if 
>>>> possible... Would you have any idea to classify some annotated(but no 
>>>> side-effect) functions?
>>>
>>> The macro magic I can think of would need to change the syntax of the 
>>> function definition - for example that is how the SYSCALL_DEFINE*() 
>>> macros work.
>>
>> Would you mean something like the below macro? :)
>>
>> NOKPROBE_SYMBOL(int, func_ptr_is_kernel_text)(void *ptr)
> 
> I think this is rather ugly and harder to maintain. The whole _point_ of 
> such annotations is to make them 'easy on the eyes', to make it easy to 
> skip a 'noinline', 'noprobe' or 'notrace' tag.
> 
> Using something like NOKPROBE_SYMBOL() makes the whole construct ugly and 
> attention seeking.

Hmm, by the way how about Steven's idea? A macro like EXPORT_SYMBOL?
At least for kprobes_blacklist, which is defined/maintained in kprobes.c
for some symbols(*), that is useful for updating it because we can
put it near the function definition.

* These symbols can not moves to other section because it already
in a different section.

Of course, still this is not a big problem since there are a few symbols
in the kprobe_blacklist.

> So until compilers get smarter (or there's some compiler trick I haven't 
> noticed) lets stay with the separate section - it's not the end of the 
> world, the (effective) 'noinline' aspect of noprobes changes code 
> generation anyway.

I see. :)

So, would you pull this series ? Or I need any update?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


