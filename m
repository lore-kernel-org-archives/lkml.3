Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3CKQ0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:26:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42779 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3CKQ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:26:46 -0400
Message-ID: <1363019193.14933.14.camel@laptop>
Subject: Re: [PATCHv2] perf: Fix vmalloc ring buffer free function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 11 Mar 2013 17:26:33 +0100
In-Reply-To: <20130311112105.GA9737@krava.brq.redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
	 <1362994843.10972.40.camel@laptop>
	 <20130311112105.GA9737@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 12:21 +0100, Jiri Olsa wrote:
> >  pg_nr     = offset >> page_shift;
> >  pg_offset = offset & (1 << page_shift) - 1;
> > 
> > You just wrecked that.
> > 
> > >     handle->page &= rb->nr_pages - 1;
> 
> here's ^^^ where the handle->page becomes 0 due to (rb->nr_pages == 0)

then that'll be &= -1, which is a nop, no?

Also, you wrecked it for anything that uses some intermediate page
order (we currently don't).

