Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3IFAPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 20:15:25 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53399 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab3IFAPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 20:15:24 -0400
Date: Thu, 5 Sep 2013 17:15:08 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH] perf mem: add priv level filtering support
Message-ID: <20130906001508.GA20856@us.ibm.com>
References: <20130826131121.GA26224@quad>
 <521BD4F8.5050504@gmail.com>
 <20130828132703.GD3825@infradead.org>
 <CABPqkBTf8Ruoq1RZhLcBLkhJY1mzJLpnLsM0J_7Bz=9Eakeajg@mail.gmail.com>
 <20130828142112.GE3825@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828142112.GE3825@infradead.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090600-7182-0000-0000-000008506C1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo [acme@redhat.com] wrote:
| Em Wed, Aug 28, 2013 at 03:38:28PM +0200, Stephane Eranian escreveu:
| > On Wed, Aug 28, 2013 at 3:27 PM, Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
| > > So perhaps we should change both to (and add this to 'report' as well):
| > >
| > >     -U, --hide_kernel_symbols   hide kernel symbols
| > >     -K, --hide_user_symbols     hide user symbols
| > >
| > 
| > Well, I don't know what perf top does here but I don't want to hide
| > the samples. I simply don't want to collect them (do not appear
| > in the perf.data file). If that's what is happening in perf top, then
| > I'll be glad to use the same options.
| 
| Indeed, its for different purposes, 'perf top' when used with one of
| those options will still collect samples for all priv levels and will
| just toggle a flag to not zap the ones asked not to show when decaying
| the samples.
| 
| When the user presses 'U' or 'K' on the UI, the flags gets toggled and
| samples start being considered/zapped.
| 
| But my worry here is about consistency accross tools for the single
| letter options, so perhaps if you could use:
| 
|      -U		collect only user level samples
|      -K		collect only kernel level samples
| 
| I think it would stay consistent and clear, what do you think?

But, we use lower case qualifiers :u, :k to select user or kernel mode
monitoring. 

	perf record -e cycles		# both kernel and user
	perf record -e cycles:u ...	# just user

(tools/perf/util/parse-events.c:

        struct event_modifier {
                int eu;
                int ek;
                int eh;
                int eH;
                int eG;
                int precise;
                int exclude_GH;
        };

Will we ever need hypervisor and host monitoring for 'perf mem' ?

Or can we add a '-e' option to 'perf mem' so user can specify the events
and qualfiers same as they do for 'perf record' ?

	perf mem -e mem-loads:u record .....

(this would of course expose the mem-loads and mem-stores events to
the user)

Sukadev

