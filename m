Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3HANct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:32:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab3HANcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:32:48 -0400
Date: Thu, 1 Aug 2013 15:32:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/8] perf: Sanitize get_callchain_buffer()
Message-ID: <20130801133217.GH1032@krava.brq.redhat.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-3-git-send-email-fweisbec@gmail.com>
 <20130801130146.GE1032@krava.brq.redhat.com>
 <20130801132833.GA431@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801132833.GA431@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:28:34PM +0200, Frederic Weisbecker wrote:

SNIP

> > also for following case:
> > 
> >         count = atomic_inc_return(&nr_callchain_events);
> >         if (WARN_ON_ONCE(count < 1)) {
> >                 err = -EINVAL;
> >                 goto exit;
> >         }
> > 
> > seems like it screws the count
> 
> I'm not sure what you mean here. You mean that it could be negative when the dec is done
> outside the lock?

yes

