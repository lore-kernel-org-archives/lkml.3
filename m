Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3J3DTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:19:03 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55500 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab3J3DTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:19:01 -0400
Date: Wed, 30 Oct 2013 11:18:38 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@redhat.com
Cc: weiyang@linux.vnet.ibm.com
Subject: Re: [PATCH] perf: fix two warning in bench/numa
Message-ID: <20131030031838.GA9662@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1379839764-9245-1-git-send-email-weiyang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379839764-9245-1-git-send-email-weiyang@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103003-7014-0000-0000-000003D8FC66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear maintainer,

Is this one accepted or droped?
Or I missed the right person?

On Sun, Sep 22, 2013 at 04:49:24PM +0800, Wei Yang wrote:
>There two warnings in bench/numa, when buiding this on 32-bit machine. 
>
>The warning output is attached:
>
>bench/numa.c:1113:20: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
>bench/numa.c:1161:6: error: format ‘%lx’ expects argument of t'long unsigned int’, but argument 5 has type ‘u64’ [-Werror=format]
>
>This patch fixs these two warnings.
>
>Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
>---
> tools/perf/bench/numa.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
>index 30d1c32..a73c4ed 100644
>--- a/tools/perf/bench/numa.c
>+++ b/tools/perf/bench/numa.c
>@@ -1110,7 +1110,7 @@ static void *worker_thread(void *__tdata)
> 		/* Check whether our max runtime timed out: */
> 		if (g->p.nr_secs) {
> 			timersub(&stop, &start0, &diff);
>-			if (diff.tv_sec >= g->p.nr_secs) {
>+			if (diff.tv_sec >= (time_t)g->p.nr_secs) {
> 				g->stop_work = true;
> 				break;
> 			}
>@@ -1157,7 +1157,7 @@ static void *worker_thread(void *__tdata)
> 			runtime_ns_max += diff.tv_usec * 1000;
>
> 			if (details >= 0) {
>-				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016lx]\n",
>+				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016"PRIu64"]\n",
> 					process_nr, thread_nr, runtime_ns_max / bytes_done, val);
> 			}
> 			fflush(stdout);
>-- 
>1.7.5.4

-- 
Richard Yang
Help you, Help me

