Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaJXGCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:02:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:34635 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaJXGCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:02:37 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/16] perf tools: Add facility to export data in database-friendly way
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
	<1414061124-26830-6-git-send-email-adrian.hunter@intel.com>
Date: Fri, 24 Oct 2014 15:02:35 +0900
In-Reply-To: <1414061124-26830-6-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Thu, 23 Oct 2014 13:45:13 +0300")
Message-ID: <87lho6c8ec.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014 13:45:13 +0300, Adrian Hunter wrote:
> This patch introduces an abstraction for exporting sample
> data in a database-friendly way.  The abstraction does not
> implement the actual output.  A subsequent patch takes this
> facility into use for extending the script interface.
>
> The abstraction is needed because static data like symbols,
> dsos, comms etc need to be exported only once.  That means
> allocating them a unique identifier and recording it on each
> structure.  The member 'db_id' is used for that.  'db_id'
> is just a 64-bit sequence number.

Can we do it somewhere in a script not in the core code?  I don't feel
comfortable to add those bits into the core code.  What if we export
meta events like task, mmap or some user events to the script optionally
and let it process the data?

Thanks,
Namhyung


>
> Exporting centres around the db_export__sample() function
> which exports the associated data structures if they have
> not yet been allocated a db_id.
