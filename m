Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab3HOOGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:06:36 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42939 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab3HOOGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:06:35 -0400
Date: Thu, 15 Aug 2013 16:06:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] perf, tools: Add perf stat --transaction v3
Message-ID: <20130815140633.GF19750@two.firstfloor.org>
References: <1376505267-8902-1-git-send-email-andi@firstfloor.org>
 <1376505267-8902-5-git-send-email-andi@firstfloor.org>
 <20130815132637.GE1861@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815132637.GE1861@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/* Default events used for perf stat -T */
> > +static const char * const transaction_attrs[] = {
> > +	"task-clock",
> > +	"{"
> > +	"instructions,"
> > +	"cycles,"
> > +	"cpu/cycles-t/,"
> > +	"cpu/tx-start/,"
> > +	"cpu/el-start/,"
> > +	"cpu/cycles-ct/"
> > +	"}"
> > +};
> > +
> > +/* More limited version when the CPU does not have all events. */
> > +static const char * const transaction_limited_attrs[] = {
> > +	"task-clock",
> > +	"{"
> > +	"instructions,"
> > +	"cycles,"
> > +	"cpu/cycles-t/,"
> > +	"cpu/tx-start/"
> > +	"}"
> > +};
> > +
> > +/* must match the transaction_attrs above */
> 
> Match in what way? It kinda matches the first one (transaction_attrs):

The second is just the beginning of the first.

The { } don't count for matches.

For the limited run the comparisons of the elements that are not there
fail.

> 
> enum {
> 	T_TASK_CLOCK,        ==	"task-clock",
> 	T_INSTRUCTIONS,      == "instructions,"
> 	T_CYCLES,	     == "cycles,"
> 	T_CYCLES_IN_TX,      ~= "cpu/cycles-t/,"
> 	T_TRANSACTION_START, != "cpu/tx-start/,"
> 	T_ELISION_START,     ~= "cpu/el-start/,"
> 	T_CYCLES_IN_TX_CP,   != "cpu/cycles-ct/"
> };

I did a quick test of the fallback path by manually disabling the events,
and it seemed to work, but it's really for POWER based on Michael E's feedback.

> 
> Also the enum numbers won't match the array positions due to the '{'
> grouping (?) entries, so, without looking further, how can this match?
> Reading on...

The match is on the result array.  The results don't contain the { } 
as individual elements.

Anyways I use this option pretty heavily and the results are good
to my knowledge.

-Andi

