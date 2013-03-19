Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab3CSM6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:58:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46451 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab3CSM6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:58:43 -0400
Message-ID: <1363697902.22553.43.camel@laptop>
Subject: Re: [PATCH] perf,x86: fix uninitialized pt_regs in
 intel_pmu_drain_bts_buffer()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Salman Qazi <sqazi@google.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Date: Tue, 19 Mar 2013 13:58:22 +0100
In-Reply-To: <CABPqkBSmVzk=0nvHiuk-+XSfNX8ODXWKeJ+jUu2482=NvMoghg@mail.gmail.com>
References: <20130318134645.GA3278@quad> <1363696984.22553.41.camel@laptop>
	 <CABPqkBSmVzk=0nvHiuk-+XSfNX8ODXWKeJ+jUu2482=NvMoghg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 13:50 +0100, Stephane Eranian wrote:
> > Should we not replace:
> >
> >         regs.ip     = 0;
> >
> > with that memset? It avoids the memset work in a few cases and
> removes
> > the then superfluous clearing of the IP field.
> >
> We could drop it because it's covered by the memset().

Yeah, but also place the memset a little lower than you did, avoids the
stack writes when not needed.

> The issue here was that you eventually end up in code_segment_base()
> which
> looks at other uninitialized fields in pt_regs and may cause breakage.

Right, your changelog said so ;-)

