Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaAOGYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 01:24:02 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54339 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaAOGXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:23:49 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-21-52d629733446
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf tools: Spare double comparison of callchain first entry
References: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
	<1389713836-13375-3-git-send-email-fweisbec@gmail.com>
Date: Wed, 15 Jan 2014 15:23:46 +0900
In-Reply-To: <1389713836-13375-3-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Tue, 14 Jan 2014 16:37:15 +0100")
Message-ID: <87y52h930t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 16:37:15 +0100, Frederic Weisbecker wrote:
> When a new callchain child branch matches an existing one in the rbtree,
> the comparison of its first entry is performed twice:
>
> 1) From append_chain_children() on branch lookup
>
> 2) If 1) reports a match, append_chain() then compares all entries of
> the new branch against the matching node in the rbtree, and this
> comparison includes the first entry of the new branch again.

Right.

>
> Lets shortcut this by performing the whole comparison only from
> append_chain() which then returns the result of the comparison between
> the first entry of the new branch and the iterating node in the rbtree.
> If the first entry matches, the lookup on the current level of siblings
> stops and propagates to the children of the matching nodes.

Hmm..  it looks like that I thought directly calling append_chain() has
some overhead - but it's not.

>
> This results in less comparisons performed by the CPU.

Do you have any numbers?  I suspect it'd not be a big change, but just
curious.

>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
