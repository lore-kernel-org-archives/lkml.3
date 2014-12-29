Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaL2HG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 02:06:59 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48461 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaL2HG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 02:06:58 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Mon, 29 Dec 2014 16:08:04 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 18/37] perf tools: Remove thread when map groups
 initialization failed
Message-ID: <20141229070804.GA6081@sejong>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-19-git-send-email-namhyung@kernel.org>
 <549F52C4.7090205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <549F52C4.7090205@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 05:45:56PM -0700, David Ahern wrote:
> On 12/24/14 12:15 AM, Namhyung Kim wrote:
> >Otherwise it'll break the machine->threads tree.
> >
> >Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> >---
> >  tools/perf/util/machine.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> >diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> >index 031bace39fdc..beae6e8fe789 100644
> >--- a/tools/perf/util/machine.c
> >+++ b/tools/perf/util/machine.c
> >@@ -411,6 +411,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
> >  		 * leader and that would screwed the rb tree.
> >  		 */
> >  		if (thread__init_map_groups(th, machine)) {
> >+			rb_erase(&th->rb_node, &machine->threads);
> >  			thread__delete(th);
> >  			return NULL;
> >  		}
> >
> 
> Can you move the thread__init_map_groups() before the thread is added to the
> rbtree? If no, you need to delay setting 'machine->last_match = th'
> otherwise it references a deleted thread.

You're right - I'll move the setting after the thread__init_map_groups().

Thanks,
Namhyung
