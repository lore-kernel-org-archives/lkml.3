Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbaKTNqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:46:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:48413 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751161AbaKTNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:46:42 -0500
Date: Thu, 20 Nov 2014 08:46:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: byungchul.park@lge.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        seungho1.park@lge.com, jolsa@redhat.com
Subject: Re: [PATCH v5 2/2] tracing: add additional marks to signal very
 large time
Message-ID: <20141120084617.4219e135@gandalf.local.home>
In-Reply-To: <87ioiapft4.fsf@sejong.aot.lge.com>
References: <1416442535-31188-1-git-send-email-byungchul.park@lge.com>
	<1416442535-31188-3-git-send-email-byungchul.park@lge.com>
	<20141119200604.6b57266d@gandalf.local.home>
	<87ioiapft4.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014 15:05:43 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Steve and Byungchul,
> 
> On Wed, 19 Nov 2014 20:06:04 -0500, Steven Rostedt wrote:
> > On Thu, 20 Nov 2014 09:15:35 +0900
> > byungchul.park@lge.com wrote:
> >> -static unsigned long preempt_mark_thresh_us = 100;
> >> +#undef MARK
> >> +#define MARK(v, s) {.val = v, .sym = s}
> >> +/* trace overhead mark */
> >> +static const struct trace_mark {
> >> +	unsigned long long	val; /* unit: nsec */
> >> +	char			sym;
> >> +} mark[] = {
> >> +	MARK(1000000000ULL	, '$'), /* 1 sec */
> >> +	MARK(1000000ULL		, '#'), /* 1000 usecs */
> >> +	MARK(100000ULL		, '!'), /* 100 usecs */
> >> +	MARK(10000ULL		, '+'), /* 10 usecs */
> >> +	MARK(0ULL		, ' '), /* 0 usecs */
> >> +};
> >> +#undef MARK
> >> +
> >> +char trace_find_mark(unsigned long long d)
> >> +{
> >> +	int i;
> >> +	int size = ARRAY_SIZE(mark);
> >> +
> >> +	for (i = 0; i < size; i++) {
> >> +		if (d >= mark[i].val)
> >> +			break;
> >> +	}
> >> +
> >> +	return (i == size)? ' ' : mark[i].sym;
> >
> > Change this to:
> >
> > 	/* The break from loop must have been hit */
> > 	if (WARN_ON_ONCE(i == size))
> > 		return ' ';
> 
> I think it's impossible since it's always true that 'd >= 0'.
> 

It is impossible if this code never changes. But we all know that
wont be the case :-)

-- Steve
 
