Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3CKMP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 08:15:58 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:44307 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3CKMP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:15:57 -0400
Date: Mon, 11 Mar 2013 13:15:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCHv2] perf: Fix vmalloc ring buffer free function
Message-ID: <20130311121553.GB18098@gmail.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
 <1362994843.10972.40.camel@laptop>
 <20130311112105.GA9737@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311112105.GA9737@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> > >  struct page *
> > >  perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
> > >  {
> > > -	if (pgoff > (1UL << page_order(rb)))
> > > +	if (pgoff > page_nr(rb))
> > >  		return NULL;
> > 
> > This is just wrong.. you have page_nr() be 1+2^n, but the comparison is
> 
> > '>' not '>=', this means we get a range of 2+2^n, not the desired 1+2^n.
> 
> ouch, missed that one

So, because this is perf/urgent which I want to send Linuswards, I removed 
the commit to not hold up other bits - please resend the whole patch once 
everything is fixed.

Thanks,

	Ingo
