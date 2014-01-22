Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaAVAwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 19:52:15 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49092 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaAVAwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 19:52:12 -0500
Message-ID: <52DF1633.1070404@hitachi.com>
Date: Wed, 22 Jan 2014 09:52:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: Re: [PATCH v6 1/8] x86: allow to handle errors in text_poke
 function family
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz> <1386690140-19941-2-git-send-email-pmladek@suse.cz> <20140114182029.27fa13f9@gandalf.local.home> <1390309237.14199.16.camel@pathway.suse.cz> <20140121090229.5936c2ba@gandalf.local.home>
In-Reply-To: <20140121090229.5936c2ba@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/01/21 23:02), Steven Rostedt wrote:
> On Tue, 21 Jan 2014 14:00:37 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
>>>> There are some situations where it is hard to recover from an error. Masami
>>>> Hiramatsu <masami.hiramatsu.pt@hitachi.com> suggested to create
>>>> text_poke*_or_die() variants for this purpose.
>>>
>>> I don't like the "_or_die()". Although I don't care much about it, I'm
>>> thinking the x86 maintainers might not like it either.
>>>
>>> What about just doing the test in the places that would call "or_die"?
>>>
>>> 	ret = text_poke*();
>>> 	BUG_ON(ret);
>>
>> Exactly this solution has been used in v5 of this patch set, see 
>> https://lkml.org/lkml/2013/12/3/258
>>
>> Masami suggested to use the "or_die()" because BUG_ON() was used on most
>> locations, see https://lkml.org/lkml/2013/12/6/1107
> 
> If BUG_ON() is used in most locations, then we can make text_poke()
> default to bug, and the just have a text_poke_safe() function that does
> not bug. Or some similar name.

Unfortunately, since still there is BUG_ON() in text_poke() when
we failed to modify text, I think text_poke_safe() is not a good
name too.

> The "_die" has a bad taste in several developers mouth ;-)

What about using text_poke() for BUG_ON and __text_poke()
for returning an error ? This may not change caller sites.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


