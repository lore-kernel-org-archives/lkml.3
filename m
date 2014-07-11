Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaGKC0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:26:43 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54832 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGKC0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:26:42 -0400
Message-ID: <53BF4B5A.3000302@hitachi.com>
Date: Fri, 11 Jul 2014 11:26:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
References: <20140703200750.648550267@goodmis.org> <20140710213620.GA19858@treble.redhat.com> <alpine.LNX.2.00.1407102342050.8779@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1407102342050.8779@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/11 6:44), Jiri Kosina wrote:
> On Thu, 10 Jul 2014, Josh Poimboeuf wrote:
> 
>> I did some testing with kpatch and I found one minor issue.  The dynamically
>> allocated trampoline seems to confuse dump_stack() somewhat.
>>
>> I added a dump_stack() call in my ftrace_ops callback function
>> (kpatch_ftrace_handler) which had a filter on meminfo_proc_show().
> 
> Interesting. Are you using dwarf2 unwinder for stack dumping by any 
> chance? It seems to get things right here. Will look into it more 
> tomorrow.

Hmm, can dwarf2 unwinder work on the trampoline method?
Since the trampoline just a copy of instructions which
will not have CFI(which is stored in dwarf section),
I guess it may not work...
Frame pointer (push bp and save sp to bp on the entry) can
work anyway.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


