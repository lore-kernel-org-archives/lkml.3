Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab3HMHiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:38:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47404 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab3HMHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:38:50 -0400
Date: Tue, 13 Aug 2013 09:38:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, leiwen@marvell.com
Subject: Re: false nr_running check in load balance?
Message-ID: <20130813073842.GP27162@twins.programming.kicks-ass.net>
References: <CALZhoSQgw_-UaF0VOMjMqRJC8D4oQTBp4Bv=zJS+x0Wu97f2FQ@mail.gmail.com>
 <20130812144309.GK27162@twins.programming.kicks-ass.net>
 <CALZhoSRyfE78GbiJqVRvUrbJRq_NhSqYbK8vnxNP8kS9xz9qVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSRyfE78GbiJqVRvUrbJRq_NhSqYbK8vnxNP8kS9xz9qVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 12:45:12PM +0800, Lei Wen wrote:
> > Not quite right; I think you need busiest->cfs.h_nr_running.
> > cfs.nr_running is the number of entries running in this 'group'. If
> > you've got nested groups like:
> >
> >  'root'
> >    \
> >    'A'
> >    / \
> >   t1 t2
> >
> > root.nr_running := 1 'A', even though you've got multiple running tasks.
> >
> 
> You're absolutely right for this. :)
> I miss it for not considering the group case...
> 
> Then do you think it is necessary to do below change in load_balance() code?
>  -       if (busiest->nr_running > 1) {
>  +       if (busiest->cfs.h_nr_running > 1) {
> 

Yes I think that would be fine.
