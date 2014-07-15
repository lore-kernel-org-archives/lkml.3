Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbaGOBVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 21:21:06 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39597 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaGOBVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 21:21:05 -0400
Message-ID: <53C481F8.2040508@hitachi.com>
Date: Tue, 15 Jul 2014 10:20:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
        Seth Jennings <sjenning@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
References: <20140703200750.648550267@goodmis.org>  <20140710213620.GA19858@treble.redhat.com>  <alpine.LNX.2.00.1407102342050.8779@pobox.suse.cz>  <53BF4B5A.3000302@hitachi.com>  <alpine.LNX.2.00.1407111523270.8779@pobox.suse.cz>  <20140711142928.GA13037@treble.redhat.com> <53C333D9.4030907@hitachi.com>  <87ion02yx3.fsf@sejong.aot.lge.com>  <53C39250.20200@hitachi.com> <1405347521.1745.37.camel@leonhard>
In-Reply-To: <1405347521.1745.37.camel@leonhard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/14 23:18), Namhyung Kim wrote:
> 2014-07-14 (월), 17:18 +0900, Masami Hiramatsu:
>> (2014/07/14 16:16), Namhyung Kim wrote:
>>> Hi Masami,
>>>
>>> On Mon, 14 Jul 2014 10:35:21 +0900, Masami Hiramatsu wrote:
>>>> (2014/07/11 23:29), Josh Poimboeuf wrote:
>>>>> Here's the same stack trace with this patch:
>>>>>
>>>>>   [ 1314.612287]  [<ffffffff81700312>] dump_stack+0x45/0x56
>>>>>   [ 1314.612290]  [<ffffffff8125f5b0>] ? meminfo_proc_open+0x30/0x30
>>>>>   [ 1314.612293]  [<ffffffffa080a494>] kpatch_ftrace_handler+0x14/0xf0 [kpatch]
>>>>>   [ 1314.612306]  [<ffffffffa00160c4>] 0xffffffffa00160c3
>>>>
>>>> Here, this still has a wrong entry. Maybe the trampline doesn't setup
>>>> frame pointer (bp) correctly.
>>>
>>> Hmm.. are you saying about the hex address above?  I guess it's a valid
>>> entry in the (dynamic) trampoline, but has no symbol..
>>
>> Ah, indeed. (BTW, why is it one less than the address ...? printk's spec?)
> 
> Argh, it seems like a bug in printk's %pB format processing.. :-/
> 
> It subtract 1 from the address for stacktrace.  Please see the commit
> 0f77a8d37825 ("vsprintf: Introduce %pB format specifier") and
> 71f9e59800e5 ("x86, dumpstack: Use %pB format specifier for stack
> trace") for details.  But it should restore the original address when it
> failed to find a symbol for that address.

Ah I see.

> 
> I'll send a fix soon.

Thanks! :)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


