Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbaJaQvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:51:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:7663 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754100AbaJaQvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:51:48 -0400
Date: Fri, 31 Oct 2014 12:51:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: byungchul.park@lge.com
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing, function_graph: fix micro seconds notation
 in comment
Message-ID: <20141031125146.17a3f105@gandalf.local.home>
In-Reply-To: <20141024010742.GB18008@byungchulpark-X58A-UD3R>
References: <1414052242-9828-1-git-send-email-byungchul.park@lge.com>
 <1414052242-9828-2-git-send-email-byungchul.park@lge.com>
 <87fveee2tg.fsf@sejong.aot.lge.com>
 <20141024010742.GB18008@byungchulpark-X58A-UD3R>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014 10:07:42 +0900
Byungchul Park <byungchul.park@lge.com> wrote:

 
> > >  	/* Signal a overhead of time execution to the output */
> > >  	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
> > > -		/* Duration exceeded 100 msecs */
> > > +		/* Duration exceeded 100 usecs */
> > >  		if (duration > 100000ULL)
> > >  			ret = trace_seq_puts(s, "! ");
> > > -		/* Duration exceeded 10 msecs */
> > > +		/* Duration exceeded 10 usecs */
> > >  		else if (duration > 10000ULL)
> > 
> > I thought the duration was in usec, but it seems not, it's in nsec, hmm.
> > Then this exceeding 10/100 usec is not meaningful - what about increaing
> > numbers in the conditional so that it can match to the comment?  That
> > will eliminate the need of the patch 2.

No, please keep this to 10/100 usecs. I do analyze functions that take
that little of time.

> 
> The approach you suggested also looks good to me. But I just wonder if it
> would be ok even if it changes meaning of the marks, "!", "+", because the
> marks have used with the meaning of exceeding 10/100 usec until now.
> 
> Isn't there anything wrong with increasing numbers in the conditions? :)
> 
> > 
> > Also I think msecs_str in trace_print_graph_duration() should be renamed
> > to usecs_str.
> 
> I agree. It should be also renamed. Such words made me hard to understand
> the code correctly. :(
> 

Yeah, this code has been here forever. It came from the original
latency-tracer in the -rt patch. I was so use to calling 'msecs' as
microseconds in this code, that I didn't realize the problem ;-)

Anyway, feel free to resend this patch fixing the msecs_str.

Thanks!

-- Steve


> > 
> > Thanks,
> > Namhyung
> > 
> > 
> > >  			ret = trace_seq_puts(s, "+ ");
> > >  	}
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

