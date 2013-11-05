Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3KEOBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:01:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab3KEOBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:01:21 -0500
Date: Tue, 5 Nov 2013 15:00:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v4 2/4] perf stat: add event unit and scale support
Message-ID: <20131105140030.GA30283@krava.brq.redhat.com>
References: <1383231582-15856-1-git-send-email-eranian@google.com>
 <1383231582-15856-3-git-send-email-eranian@google.com>
 <20131101105722.GA1088@krava.brq.redhat.com>
 <CABPqkBRXPYHNmCbcGDvqSNxY_zWfUiy3S3_9SasrVw9nbNL9Mg@mail.gmail.com>
 <20131104145110.GA2805@krava.brq.redhat.com>
 <CABPqkBQ1Kv9MMBhRdNoBA4k=n=cGVQtuUn810P7-PSu_SRwLug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ1Kv9MMBhRdNoBA4k=n=cGVQtuUn810P7-PSu_SRwLug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 02:34:45PM +0100, Stephane Eranian wrote:
> Hi,
> 
> One thing I realized while testing is that we cannot simply add the
> unit printout like that.
> This may break all the scripts people may have written to parse the
> output of perf stat.

isn't it what the -x output is meant for?

  perf stat -x, ...

  1.738605,task-clock
  367,context-switches
  0,cpu-migrations
  272,page-faults
  6722006,cycles
  2592661,stalled-cycles-frontend
  1935855,stalled-cycles-backend
  4324013,instructions
  823229,branches
  11192,branch-misses

> I think we need to make the display of the unit optional. If I do:
>    $ perf stat -e cycles ls
> 
> The output should remain as it was before and not show:
> $ perf stat -e cycles ls
>       22782847475 ? cycles

maybe we should display just space ' ' instead
of the '?' ...seems confusing

> 
> So I think we need a --show-unit option. It would be off by default.
> Of course doing this causes a mess with the current code because
> of all the various printf() in builtin-stat.c but I think it is better for
> the end user.
> 
> Any opinion?

I haven't checked by I think we changed the default perf stat
output in the past without any fuzz

maybe just keep the -x output or add the unit
to the end of the line

jirka
