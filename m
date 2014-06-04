Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaFDPji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:39:38 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60173 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbaFDPjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:39:36 -0400
Date: Wed, 4 Jun 2014 08:39:11 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: Fw: Re: [PATCH 1/1] powerpc/perf: Adjust callchain based on
 DWARF debug info
Message-ID: <20140604153910.GA16430@us.ibm.com>
References: <20140530155925.GF7427@krava.brq.redhat.com>
 <20140602141219.GB7861@krava.brq.redhat.com>
 <20140603074710.GA30870@us.ibm.com>
 <20140604120801.GE5555@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604120801.GE5555@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060415-0320-0000-0000-000003757FE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| On Tue, Jun 03, 2014 at 12:47:10AM -0700, Sukadev Bhattiprolu wrote:
| 
| SNIP
| 
| > | 
| > | 
| > | could you please change this, so it's nop for arch != powerpc
| > | via #ifdef I guess.. or some other smart way ;-)
| > 
| > I was trying to avoid the #ifdef in the middle of the function.
| > 
| > How about adding a PERF_CONTEXT_IGNORE and doing something like this:
| 
| hum, 2 arch calls.. seems too complicated.. :-\

Other than an 'arch_' prefix in their name the non-powerpc functions
themselves are trivial, no ? 

| 
| so if you are already introducing PERF_CONTEXT_IGNORE, why
| dont we go with the chain duplication/fixing in arch code
| you mentioned before?
| 
| this way the callchain loop stays simple and it's extendbable
| to future changes (I think u mentioned we could change more
| than one entry in future..?)

The memdup() on each call chain entry can impact performance for
powerpc.  AFAICT, only one entry needs to be adjusted, so the memdup()
looked like an overkill.

| 
| thoughts.. anyone? ;-)
| 
| thanks,
| jirka

