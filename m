Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbbAPNaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 08:30:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:46761 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751353AbbAPNaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 08:30:25 -0500
Date: Fri, 16 Jan 2015 08:30:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RESEND PATCH v2 1/2] tracing: Add array printing helpers
Message-ID: <20150116083049.706f8f16@grimm.local.home>
In-Reply-To: <20150116101413.GA2898@e104805>
References: <1421340659-18063-1-git-send-email-javi.merino@arm.com>
	<20150115212202.7939072a@grimm.local.home>
	<20150116101413.GA2898@e104805>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015 10:14:14 +0000
Javi Merino <javi.merino@arm.com> wrote:


> > BUG() is a bit extreme don't you think? I'm not sure it even
> > deserves a WARN_ON().
> 
> Ok, I used BUG() because that's what you suggested:
> 
> http://article.gmane.org/gmane.linux.kernel/1846749
> 

Whoever suggested that was an idiot ;-)

I know why I suggested that but looking at it again with a clearer head
I think it's better not to bug, or even warn. It's on the output side,
for some reason I was thinking it was on the input (saving to buffer)
side.

> The only way I could think of turning it into a BUILD_BUG was by
> moving it to the __print_array macro, but I think it's ugly.

BUILD_BUG is probably better even if it is ugly. But for now, as this
is only to output the data not to save it, printing is better.

> 
> > I would suggest doing:
> > 
> > 			trace_seq_printf(p, "BAD SIZE:%d 0x%x",
> > el_size, *(u8 *)ptr);
> > 			el_size = 8;
> > 
> > No need to go crashing the kernel or even messing with dmesg over
> > somebody's tracepoint mistake.
> 
> Ok, I'll change it to that.
> 
> > The rest looks fine.
> > 
> > > +		}
> > > +		prefix = ",";
> > > +		ptr += el_size / 8;
> > > +	}
> > > +
> > > +	trace_seq_putc(p, '}');
> > > +	trace_seq_putc(p, 0);
> > 
> > I need to add a trace_seq_terminate() for this.
> 
> That would make it more readable.  Cheers,

It's on my todo list :-)

Thanks!

-- Steve

