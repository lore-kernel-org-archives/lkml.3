Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaJUBvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 21:51:38 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38299 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaJUBvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 21:51:37 -0400
Message-ID: <5445BC23.6080207@hitachi.com>
Date: Tue, 21 Oct 2014 10:51:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kprobes: introduce ARCH_HANDLES_KPROBES_ON_FTRACE
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com> <1413387978-984-2-git-send-email-heiko.carstens@de.ibm.com> <54446B92.1040507@hitachi.com> <20141020145321.0af7a4dd@gandalf.local.home>
In-Reply-To: <20141020145321.0af7a4dd@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/21 3:53), Steven Rostedt wrote:
> On Mon, 20 Oct 2014 10:55:30 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>> Hmm, this looks a bit not straight. Maybe we'd better introduce a local
>> check_ftrace_location() function which always returns 0 if
>> CONFIG_ARCH_HANDLES_KPROBES_ON_FTRACE(with a comment! :)) as below.
>>
>> int check_ftrace_location(kp)
>> {
>> 	unsigned long ftrace_address;
>>
>> 	/* If an architecture handles kprobes on ftrace, we don't check it */
>> 	if (IS_ENABLED(CONFIG_ARCH_HANDLES_KPROBES_ON_FTRACE))
>> 		return 0;
>>
>> 	...
>> }
> 
> We can also just make that function weak, and let the archs override
> the default behavior?

Ah, that will be simpler and we don't need new Kconfig.

Thank you!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


