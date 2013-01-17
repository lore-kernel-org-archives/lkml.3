Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3AQVoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:44:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15308 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab3AQVoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:44:23 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1dK1Tq4abSwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=daFlbPKOXuoA:10 a=M9TZjGZPBGT3v9G97LcA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358459061.23211.47.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] slub: Check for page NULL before doing the
 node_match check
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Date: Thu, 17 Jan 2013 16:44:21 -0500
In-Reply-To: <1358458583.11051.7.camel@edumazet-glaptop>
References: <1358446258.23211.32.camel@gandalf.local.home>
	 <1358447864.23211.34.camel@gandalf.local.home>
	 <0000013c4a69a2cf-1a19a6f6-e6a3-4f06-99a4-10fdd4b9aca2-000000@email.amazonses.com>
	 <1358458583.11051.7.camel@edumazet-glaptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 13:36 -0800, Eric Dumazet wrote:

> > Index: linux/mm/slub.c
> > ===================================================================
> > --- linux.orig/mm/slub.c	2013-01-15 10:42:08.490183607 -0600
> > +++ linux/mm/slub.c	2013-01-17 15:27:48.973051155 -0600
> > @@ -1993,8 +1993,8 @@ static inline void flush_slab(struct kme
> >  	deactivate_slab(s, c->page, c->freelist);
> > 
> >  	c->tid = next_tid(c->tid);
> > -	c->page = NULL;
> >  	c->freelist = NULL;
> > +	c->page = NULL;
> >  }
> > 
> >  /*
> > @@ -2227,8 +2227,8 @@ redo:
> >  	if (unlikely(!node_match(page, node))) {
> >  		stat(s, ALLOC_NODE_MISMATCH);
> >  		deactivate_slab(s, page, c->freelist);
> > -		c->page = NULL;
> >  		c->freelist = NULL;
> > +		c->page = NULL;
> >  		goto new_slab;
> >  	}
> > 
> > @@ -2239,8 +2239,8 @@ redo:
> >  	 */
> >  	if (unlikely(!pfmemalloc_match(page, gfpflags))) {
> >  		deactivate_slab(s, page, c->freelist);
> > -		c->page = NULL;
> >  		c->freelist = NULL;
> > +		c->page = NULL;
> >  		goto new_slab;
> >  	}
> > 
> 
> Without appropriate barriers, this change is a shoot in the dark.

Totally agree.

-- Steve


