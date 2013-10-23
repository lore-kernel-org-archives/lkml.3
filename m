Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab3JWHHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:07:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:19599 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab3JWHHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:07:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="423298323"
Date: Wed, 23 Oct 2013 00:07:48 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH v2 0/3] perf,x86: add Intel RAPL PMU support
Message-ID: <20131023070748.GB7756@tassilo.jf.intel.com>
References: <1381416608-2741-1-git-send-email-eranian@google.com>
 <20131010180049.GD9929@pd.tnic>
 <20131016124627.GA2611@gmail.com>
 <CABPqkBRQcisi8ukhD=6fKMq+iqwM+Qgxd3=jo82EUJB5coXs1A@mail.gmail.com>
 <20131016175302.GB4100@infradead.org>
 <CABPqkBSs1YwTiy_nkyXc89vg8-Tg=ONqCk930A+ksoLKsGLdHw@mail.gmail.com>
 <20131017081420.GB22705@gmail.com>
 <CABPqkBTBqEUU9p3SwNTXwwJ9j7VQXdofA5DzyoDmw+xJBE-uUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTBqEUU9p3SwNTXwwJ9j7VQXdofA5DzyoDmw+xJBE-uUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> # perf stat -a -e power/energy-cores/,power/energy-pkg/,ref-cycles -I
> 1000 sleep 1000
> #           time        unit            counts events
>      1.000264953      Joules              2.09 power/energy-cores/
>   [100.00%]
>      1.000264953      Joules              5.94 power/energy-pkg/
>      1.000264953                   160,530,320 ref-cycles
>      2.000640422      Joules              2.07 power/energy-cores/
>      2.000640422      Joules              5.94 power/energy-pkg/
>      2.000640422                   152,673,056 ref-cycles
>      3.000964416      Joules              2.08 power/energy-cores/
>      3.000964416      Joules              5.93 power/energy-pkg/
>      3.000964416                   158,779,184 ref-cycles

Can you add some column marker that there is no unit (like -) ? 

This is just in case someone wants to parse this with a tool. Yes they
should be using -x, but it is still better to be always parseable.

-Andi
