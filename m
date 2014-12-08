Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbaLHQEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:04:07 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:42799 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755489AbaLHQEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:04:04 -0500
Date: Mon, 8 Dec 2014 16:04:52 +0000
From: Dave P Martin <Dave.Martin@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Javi Merino <Javi.Merino@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH v6 1/9] tracing: Add array printing helpers
Message-ID: <20141208160451.GC4956@e103592.cambridge.arm.com>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-2-git-send-email-javi.merino@arm.com>
 <20141208104210.69874f14@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208104210.69874f14@gandalf.local.home>
Thread-Topic: [RFC PATCH v6 1/9] tracing: Add array printing helpers
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 03:42:10PM +0000, Steven Rostedt wrote:
> On Fri,  5 Dec 2014 19:04:12 +0000
> "Javi Merino" <javi.merino@arm.com> wrote:

[...]

> > +
> > +DEFINE_PRINT_ARRAY(u8, unsigned int, "0x%x");
> > +DEFINE_PRINT_ARRAY(u16, unsigned int, "0x%x");
> > +DEFINE_PRINT_ARRAY(u32, unsigned int, "0x%x");
> > +DEFINE_PRINT_ARRAY(u64, unsigned long long, "0x%llx");
> > +
> 
> I would really like to avoid adding a bunch of macros for each type.
> Can't we have something like this:
> ftrace_print_array(struct trace_seq *p, void *buf, int buf_len, 
> 		int size)
> {
> 	char *prefix = "";
> 	void *ptr = buf;
> 
> 	while (ptr < buf + buf_len) {
> 		switch(size) {
> 		case 8:
> 			trace_seq_printf("%s0x%x", prefix,
> 				*(unsigned char *)ptr);

I think this should be *(u8 *) etc.

Otherwise, I don't have a problem with this approach.  It's less
ugly than my original.

> 			break;
> 		case 16:
> 			trace_seq_printf("%s0x%x", prefix,
> 				*(unsigned short *)ptr);
> 			break;
> 		case 32:
> 			trace_seq_printf("%s0x%x", prefix,
> 				*(unsigned int *)ptr);
> 			break;
> 		case 64:
> 			trace_seq_printf("%s0x%llx", prefix,
> 				*(unsigned long long *)ptr);
> 			break;
> 		default:
> 			BUG();
> 		}
> 		prefix = ",";
> 		ptr += size;
> 	}
> 
> }
> 
> We probably could even make the "BUG()" into a build bug, with a little
> work.

That sounds possible.

Javi?

Cheers
---Dave
