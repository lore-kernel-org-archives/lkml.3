Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab3HGR5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:57:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab3HGR5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:57:33 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=-1M68SHTH6AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=it5azkMwFzEA:10 a=20KFwNOVAAAA:8 a=GiknQDDqni5NxQtWNKQA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375898252.6848.19.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 2/2] x86/jump labels: Use etiher 5 byte or 2 byte
 jumps
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Date: Wed, 07 Aug 2013 13:57:32 -0400
In-Reply-To: <20130807174121.001163270@goodmis.org>
References: <20130807173606.872055511@goodmis.org>
	 <20130807174121.001163270@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 13:36 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0002-x86-jump-labels-Use-etiher-5-byte-or-2-byte-jumps.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Have the jump labels add a "jmp" in the assembly instead
> of a default nop. This will cause the assembler to put in
> either a 2 byte or 5 byte jmp depending on where the target
> lable is.
> 
> Then at compile time, the update_jump_label code will replace
> the jmps with either 2 or 5 byte nops.
> 
> On boot up, the code can be examined to see if the jump label
> uses either a 2 or 5 byte nop and replace it.
> 
> By allowing the jump labels to be 2 bytes, it speeds up the
> nops, not only 2 byte nops are faster than 5 byte nops, but also
> because it saves on cache foot print.
> 
>    text    data     bss     dec     hex filename
> 13403667 3666856 2998272 20068795 13239bb ../nobackup/mxtest/vmlinux-old
> 13398536 3666856 2998272 20063664 13225b0 ../nobackup/mxtest/vmlinux-new
> 
> Converting the current v3.2 trace points saved 5,131 bytes.
> As more places use jump labels, this will have a bigger savings.
> 

FYI, I didn't bother changing the change logs, so these numbers may be
totally bogus now.

-- Steve


