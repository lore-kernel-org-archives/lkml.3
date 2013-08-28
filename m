Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3H1OWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab3H1OW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:22:29 -0400
Date: Wed, 28 Aug 2013 11:21:12 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH] perf mem: add priv level filtering support
Message-ID: <20130828142112.GE3825@infradead.org>
References: <20130826131121.GA26224@quad>
 <521BD4F8.5050504@gmail.com>
 <20130828132703.GD3825@infradead.org>
 <CABPqkBTf8Ruoq1RZhLcBLkhJY1mzJLpnLsM0J_7Bz=9Eakeajg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTf8Ruoq1RZhLcBLkhJY1mzJLpnLsM0J_7Bz=9Eakeajg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 28, 2013 at 03:38:28PM +0200, Stephane Eranian escreveu:
> On Wed, Aug 28, 2013 at 3:27 PM, Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > So perhaps we should change both to (and add this to 'report' as well):
> >
> >     -U, --hide_kernel_symbols   hide kernel symbols
> >     -K, --hide_user_symbols     hide user symbols
> >
> 
> Well, I don't know what perf top does here but I don't want to hide
> the samples. I simply don't want to collect them (do not appear
> in the perf.data file). If that's what is happening in perf top, then
> I'll be glad to use the same options.

Indeed, its for different purposes, 'perf top' when used with one of
those options will still collect samples for all priv levels and will
just toggle a flag to not zap the ones asked not to show when decaying
the samples.

When the user presses 'U' or 'K' on the UI, the flags gets toggled and
samples start being considered/zapped.

But my worry here is about consistency accross tools for the single
letter options, so perhaps if you could use:

     -U		collect only user level samples
     -K		collect only kernel level samples

I think it would stay consistent and clear, what do you think?

- Arnaldo
