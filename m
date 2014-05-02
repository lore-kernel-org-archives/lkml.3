Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaEBBbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 21:31:06 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47396 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaEBBbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 21:31:05 -0400
Message-ID: <5362F551.2030007@hitachi.com>
Date: Fri, 02 May 2014 10:30:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
References: <cover.1398958771.git.jpoimboe@redhat.com> <87ppjxcjo2.fsf@tassilo.jf.intel.com> <20140501210154.GC3907@treble.redhat.com> <20140501210601.GG2382@two.firstfloor.org>
In-Reply-To: <20140501210601.GG2382@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/02 6:06), Andi Kleen wrote:
>> When bar returns, would it skip foo and go straight back to foo's
>> caller?  If so, then it should be safe to patch foo after it jumps to
>> bar.
> 
> foo is no problem, you see it in the backtrace.
> But you don't see bar.

No, there is no "foo" in backtrace.
As Josh said, stop_machine() schedules highest priority tasks on
each running thread, as below.

buz:
  ...
  call foo -> push buz on the stack

foo:
 ...
 jmp bar

bar:
 ...
 call schedule -> push bar on the stack

Thus, we'll not see foo on the stack. However, since the tail call
doesn't return to foo, we can treat it already finished. So, there
is no consistency problem on it. :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


