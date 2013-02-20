Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935466Ab3BTU4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:56:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:22362 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474Ab3BTU4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:56:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,703,1355126400"; 
   d="scan'208";a="288439142"
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf x86: Change SandyBridge and IvyBrige instructions event to be precise
References: <1361392794-16552-1-git-send-email-jolsa@redhat.com>
Date: Wed, 20 Feb 2013 12:55:59 -0800
In-Reply-To: <1361392794-16552-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 20 Feb 2013 21:39:54 +0100")
Message-ID: <m2ppzuyaao.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:

> Changing the default 'instructions' HW event for SandyBridge and
> IvyBrige to use the available precise 'instructions' event.
>
> The precise event is defined in Intel SDM as:
>
> INST_RETIRED.ALL - Precise instruction retired event with HW to
> reduce effect of PEBS shadow in IP distribution
>
> for both SandyBridge and IvyBrige micro-archs. It allows to use
> precise modifier on 'instructions' event on SandyBridge and
> IvyBrige micro-archs which is not possible now.

Actually it's possible, you just have to use it explicitely.

This will break a lot of profiling setups that assume instructions
count on the fixed counter and use the 4/8 other counters. 
Also it will give very bad results with perf stat, which
you don't want to run with pebs.

Even worse with your change the fixed instruction counter is not
accessible anymore. So pretty much all the standard setups
that collect it in addition to other events and fill all 
the counters would break.

I don't think it should be done by default, but yes explicitely
it's quite useful.

My Haswell patchkit (in the "extended version") exposes
the precise event as "instructions-p" through sysfs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
