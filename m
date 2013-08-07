Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab3HGUd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:33:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30346 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab3HGUd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:33:28 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=8WDeNtya6e4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=FBSalxFJak0A:10 a=mMNLZszEymWbcEGo3xYA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375907606.6848.29.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 3/2] x86/jump labels: Count and display the short
 jumps used
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@akamai.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Date: Wed, 07 Aug 2013 16:33:26 -0400
In-Reply-To: <5202ABEF.10107@akamai.com>
References: <20130807173606.872055511@goodmis.org>
	 <1375898048.6848.18.camel@gandalf.local.home>
	 <CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com>
	 <5202ABEF.10107@akamai.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 16:19 -0400, Jason Baron wrote:

> The whole point of the thread started with wanting to move the default
> 'disabled' branch further out-of-line. We could get there with better
> compiler support for the 'cold' label attribute. Thus, in theory the
> whole 2-byte jmp is just an intermediate step. (Yeah, I know that
> support doesn't seem to be happening anytime soon...)
> 

Actually, Ideally, we would move the bulk of the tracing code out of
line, but we can have the jump to the tracing code still in line, and
the nop jump to it.


	[ hot path]
	jmp trace / nop
1:

	[...]


trace:
	jmp trace_main_code
	jmp 1b


Then that jmp trace can still be a 2 byte op.

-- Steve


