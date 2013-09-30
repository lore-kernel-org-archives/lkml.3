Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3I3NkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:40:22 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44552 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3I3NkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:40:20 -0400
Message-ID: <52497F3C.9070908@gmail.com>
Date: Mon, 30 Sep 2013 07:40:12 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>,
        "David (me)" <dsahern@gmail.com>
Subject: Re: [PATCH 2/3] perf stat: Don't require a workload when using system
 wide or CPU options
References: <1380400080-9211-1-git-send-email-dsahern@gmail.com> <1380400080-9211-3-git-send-email-dsahern@gmail.com> <87li2eofvd.fsf@sejong.aot.lge.com>
In-Reply-To: <87li2eofvd.fsf@sejong.aot.lge.com>
Content-Type: multipart/mixed;
 boundary="------------040403040504050509040909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040403040504050509040909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/13 2:47 AM, Namhyung Kim wrote:
>> @@ -1517,8 +1517,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>>   	} else if (big_num_opt == 0) /* User passed --no-big-num */
>>   		big_num = false;
>>
>> -	if (!argc && !perf_target__has_task(&target))
>> +	if (!argc && !perf_target__has_task(&target) &&
>> +	    !perf_target__has_cpu(&target))
>
> You can use perf_target__none() for this.

Indeed. Updated patch attached.

David


--------------040403040504050509040909
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0002-perf-stat-Don-t-require-a-workload-when-using-system.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-perf-stat-Don-t-require-a-workload-when-using-system.pa";
 filename*1="tch"

>From a7018902283b3cfc5cae8a1876e2c14f3c7c9c7e Mon Sep 17 00:00:00 2001
From: David Ahern <dsahern@gmail.com>
Date: Mon, 30 Sep 2013 07:37:37 -0600
Subject: [PATCH] perf stat: Don't require a workload when using system wide or CPU options -v2

perf-stat can do system wide counters or one or more cpus. For
these options do not require a workload to be specified.

v2: use perf_target__none per Namhyung's comment

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-stat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 6cc0aa2..db55b91 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1517,8 +1517,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && !perf_target__has_task(&target))
+	if (!argc && perf_target__none(&target))
 		usage_with_options(stat_usage, options);
+
 	if (run_count < 0) {
 		usage_with_options(stat_usage, options);
 	} else if (run_count == 0) {
-- 
1.7.10.1


--------------040403040504050509040909--
