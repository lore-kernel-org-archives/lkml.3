Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaFJP64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:58:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:34918 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750740AbaFJP6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:58:55 -0400
Date: Tue, 10 Jun 2014 11:58:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: [for-next][PATCH 6/6] tracing: Fix leak of ring buffer data
 when new instances creation fails
Message-ID: <20140610115852.0034a678@gandalf.local.home>
In-Reply-To: <87k38pbake.fsf@sejong.aot.lge.com>
References: <20140606163034.516780857@goodmis.org>
	<20140606172105.000489056@goodmis.org>
	<87k38pbake.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 14:25:21 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

 
> > +static void free_trace_buffers(struct trace_array *tr)
> > +{
> > +	if (!tr)
> > +		return;
> > +
> > +	if (tr->trace_buffer.buffer) {
> > +		ring_buffer_free(tr->trace_buffer.buffer);
> > +		tr->trace_buffer.buffer = NULL;
> > +		free_percpu(tr->trace_buffer.data);
> > +	}
> > +
> > +#ifdef CONFIG_TRACER_MAX_TRACE
> > +	if (tr->max_buffer.buffer) {
> > +		ring_buffer_free(tr->max_buffer.buffer);
> > +		tr->max_buffer.buffer = NULL;
> 
> Hmm.. why doesn't it free tr->max_buffer.data here?  And I think it's
> better to reset *_buffer.data to NULL also - maybe by adding another
> helper function free_trace_buffer()..
> 

Originally, instances didn't need them. But I'm looking now and yes
they do allocate. I guess this doesn't trigger kmem-leak checks, as I
ran creation and deletions with that running and it didn't report any
leaks.

I'll update,

Thanks!

-- Steve
