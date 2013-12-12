Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3LLKb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 05:31:57 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44826 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3LLKby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 05:31:54 -0500
Message-ID: <52A99092.6080305@hitachi.com>
Date: Thu, 12 Dec 2013 19:31:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 6/6] [RFC] kprobes/x86: Call exception handlers
 directly from do_int3/do_debug
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204012856.22118.91079.stgit@kbuild-fedora.novalocal> <20131203213904.5ff1794c@gandalf.local.home> <alpine.LRH.2.00.1312111418550.6318@twin.jikos.cz> <52A93E3A.9080600@hitachi.com> <alpine.LNX.2.00.1312121058220.1413@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1312121058220.1413@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/12 18:59), Jiri Kosina wrote:
> On Thu, 12 Dec 2013, Masami Hiramatsu wrote:
> 
>>> Yeah, it's broken. Obviously, if you happen to trigger int3 before the 
>>> notifier has been registered, it'd cause int3 exception to be unhandled. 
>>> See
>>>
>>> 	commit 17f41571bb2c4a398785452ac2718a6c5d77180e
>>> 	Author: Jiri Kosina <jkosina@suse.cz>
>>> 	Date:   Tue Jul 23 10:09:28 2013 +0200
>>>
>>> 	    kprobes/x86: Call out into INT3 handler directly instead of using notifier
>>>
>>> for one such issue that happened with jump labels.
>>>
>>>> Hmm, if there's no users of the int3 notifier, should we just remove it?
>>>
>>> Hmm, there are still uprobes, right?
>>
>> Right, uprobes still use it, however, since it only handles user-space
>> breakpoint, there is no problem.
> 
> Agreed. But therefore the notifier can't just be removed, unless uprobes 
> are converted to direct call as well (but I don't think that'd be 
> beneficial, notifier is sufficient in this case).

Ah, I don't intended to remove notify_die from do_int3, since
notify_die notifies many other exceptions too. :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


