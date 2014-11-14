Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbaKNOxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:53:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:64767 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965504AbaKNOxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:53:42 -0500
Date: Fri, 14 Nov 2014 09:53:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 12/23 v4] tracing: Remove return values of most
 trace_seq_*() functions
Message-ID: <20141114095339.79e7e51c@gandalf.local.home>
In-Reply-To: <20141114131728.GC2988@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
	<20141114011411.992510720@goodmis.org>
	<20141114131728.GC2988@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 14:17:28 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> > -int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
> > +void trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
> >  			 unsigned int len)
> >  {
> >  	unsigned char hex[HEX_CHARS];
> >  	const unsigned char *data = mem;
> >  	unsigned int start_len;
> >  	int i, j;
> > -	int cnt = 0;
> >  
> >  	if (s->full)
> > -		return 0;
> > +		return;
> >  
> >  	while (len) {
> >  		start_len = min(len, HEX_CHARS - 1);
> > @@ -334,10 +297,7 @@ int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
> >  		/* j increments twice per loop */
> >  		len -= j / 2;
> >  		hex[j++] = ' ';
> > -
> > -		cnt += trace_seq_putmem(s, hex, j);
> 
> trace_seq_putmem(s, hex, j); should stay ;-)

Ouch! Looks like I got a little happy with the delete line key stroke.

Good catch!

Thanks,

-- Steve

> 
> Best Regards,
> Petr
> 
> >  	}
> > -	return cnt;
> >  }
> >  EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
> >  
> > -- 
> > 2.1.1
> > 
> > 
