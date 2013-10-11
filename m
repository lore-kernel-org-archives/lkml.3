Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab3JKPU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:20:28 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57675 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab3JKPU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:20:27 -0400
Message-ID: <52581737.8090309@gmail.com>
Date: Fri, 11 Oct 2013 09:20:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org> <20131011055829.GA4975@gmail.com> <20131011073448.GA11064@krava.redhat.com> <52581511.2010909@gmail.com>
In-Reply-To: <52581511.2010909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/13 9:11 AM, David Ahern wrote:
> It would be nice to fix the callchain arg handler to not attempt to
> process the next argument if it is not fp or dwarf.

Specifically, something like this which maintains syntax and default fp 
option:

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 92ca541..23d782c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -766,8 +766,8 @@ int record_parse_callchain_opt(const struct option *opt,
                      opts->stack_dump_size);
  #endif /* HAVE_LIBUNWIND_SUPPORT */
         } else {
-           pr_err("callchain: Unknown -g option "
-                  "value: %s\n", arg);
+           opts->call_graph = CALLCHAIN_FP;
+           ret = 0;
             break;
         }


