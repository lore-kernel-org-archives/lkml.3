Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3LCXop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:44:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:42342 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041Ab3LCXom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:44:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,820,1378882800"; 
   d="scan'208";a="418884260"
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo\@elte.hu" <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
	<20131115063457.GB12442@gmail.com>
	<CABPqkBQ2wD_knJP9FQxThSxNng4DZhtRxeUUAW0efAs9=jBXEA@mail.gmail.com>
	<20131115103405.GA18264@gmail.com>
	<20131117034134.GA19762@tassilo.jf.intel.com>
	<20131129133340.GA25751@krava.brq.redhat.com>
	<20131202152329.GD22695@tassilo.jf.intel.com>
	<CABPqkBQuY0VDKVhFGscAtK2vZjaSJQBCEtVCk4km-bKW85Zx-A@mail.gmail.com>
Date: Tue, 03 Dec 2013 15:44:38 -0800
In-Reply-To: <CABPqkBQuY0VDKVhFGscAtK2vZjaSJQBCEtVCk4km-bKW85Zx-A@mail.gmail.com>
	(Stephane Eranian's message of "Tue, 3 Dec 2013 03:52:13 +0100")
Message-ID: <87r49tcxeh.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@google.com> writes:
>>
> I don't understand why this need to be so complicated.
> Maybe just change the error code in case of group
> overcommitment? That way, the tool could distinguish
> and report the appropriate error message.

The existing errno is an ABI.

Also that would handle this case, but there are a bazillion other 
failure cases in perf. And we can't invent new errnos for all of them.

A string error interface would cover it all.

Usually when something strange like this happens in perf I have to apply
this patch
https://lkml.org/lkml/2013/3/8/432
and use ftrace to trace it down.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
