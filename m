Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3CLP0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:26:36 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45589
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755475Ab3CLP0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:26:35 -0400
Message-ID: <1363101972.24558.3.camel@laptop>
Subject: Re: [PATCHv3] perf: Fix vmalloc ring buffer free function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 12 Mar 2013 16:26:12 +0100
In-Reply-To: <20130312135219.GA32001@krava.brq.redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
	 <1362994843.10972.40.camel@laptop>
	 <20130311112105.GA9737@krava.brq.redhat.com>
	 <1363019193.14933.14.camel@laptop>
	 <20130311164309.GG13679@krava.brq.redhat.com>
	 <1363023885.14933.16.camel@laptop>
	 <20130311180229.GI13679@krava.brq.redhat.com>
	 <20130312100502.GC1348@krava.brq.redhat.com>
	 <1363084030.14933.23.camel@laptop>
	 <20130312135219.GA32001@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 14:52 +0100, Jiri Olsa wrote:
> > @@ -373,7 +373,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
> >       rb->user_page = all_buf;
> >       rb->data_pages[0] = all_buf + PAGE_SIZE;
> >       rb->page_order = ilog2(nr_pages);
> > -     rb->nr_pages = 1;
> > +     rb->nr_pages = nr_pages;
> >  
> 
> hum, and this ^^^ breaks perf_data_size(rb) ;)
> 
> static inline unsigned long perf_data_size(struct ring_buffer *rb)
> {
>         return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
> }

How so? 0 << n keeps being 0, right?

