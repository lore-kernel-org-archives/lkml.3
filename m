Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3LKVS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:18:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:63519 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab3LKVSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:18:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,873,1378882800"; 
   d="scan'208";a="450775470"
From: Andi Kleen <andi@firstfloor.org>
To: David Ahern <dsahern@gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 13/71] perf tools: Add machine__get_thread_pid()
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
	<1386765443-26966-14-git-send-email-alexander.shishkin@linux.intel.com>
	<52A8BCCE.9010300@gmail.com>
Date: Wed, 11 Dec 2013 13:18:54 -0800
In-Reply-To: <52A8BCCE.9010300@gmail.com> (David Ahern's message of "Wed, 11
	Dec 2013 12:28:14 -0700")
Message-ID: <87fvpzulvl.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:
>
> Are you looking up the current or next task? If the former why not use
> sample->pid rather than parsing the sched_switch tracepoint?

The itrace stream doesn't have a pid field, and it needs the exact
time stamp of the switch. There may not actually be any samples
before decoding.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
