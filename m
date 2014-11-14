Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965756AbaKNPh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:37:57 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:48507 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965682AbaKNPh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:37:56 -0500
Date: Fri, 14 Nov 2014 10:37:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 10/23 v4] tracing/uprobes: Do not use return values
 of trace_seq_printf()
Message-ID: <20141114103733.03ffc40b@gandalf.local.home>
In-Reply-To: <54662133.4060405@hitachi.com>
References: <20141114011244.256115061@goodmis.org>
	<20141114011411.693008134@goodmis.org>
	<54662133.4060405@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2014 00:35:15 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
 
> >  	for (i = 0; i < tu->tp.nr_args; i++) {
> >  		struct probe_arg *parg = &tu->tp.args[i];
> >  
> > -		if (!parg->type->print(s, parg->name, data + parg->offset, entry))
> > -			goto partial;
> > +		parg->type->print(s, parg->name, data + parg->offset, entry);
> 
> In 7/23 you've left loop canceling path, why don't you do same thing here?

While rebasing this series on my latest code, this patch conflicted. I
notice the difference too (just two minutes ago!).

I agree, it should break out still.

Srikar, can I still have your Reviewed-by if I do that?

-- Steve

> 
> Thank you,
> 
> >  	}
> >  
> > -	if (trace_seq_puts(s, "\n"))
> > -		return TRACE_TYPE_HANDLED;
> > +	trace_seq_puts(s, "\n");
> >  
> > -partial:
> > -	return TRACE_TYPE_PARTIAL_LINE;
> > +	return trace_handle_return(s);
> >  }
> >  
> >  typedef bool (*filter_func_t)(struct uprobe_consumer *self,
> 
> 
> 

