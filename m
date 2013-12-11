Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab3LKVC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:02:28 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50000 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3LKVCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:02:21 -0500
Message-ID: <52A8D2DA.7050409@gmail.com>
Date: Wed, 11 Dec 2013 14:02:18 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf list: fix --raw-dump
References: <1386756980-23121-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1386756980-23121-1-git-send-email-artagnon@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080000000604010104080007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080000000604010104080007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/13, 3:16 AM, Ramkumar Ramachandra wrote:
> While adding usage information, 44d742e (perf list: Add usage,
> 2013-10-30) broke
>
>    $ perf list --raw-dump
>
> by asking parse_options() to stop at
> non-option (PARSE_OPT_STOP_AT_NON_OPTION), hence parsing the option
> --raw-dump and barfing. Ask it to keep unknown options
> unparsed (PARSE_OPT_KEEP_UNKNOWN) so that we have a chance to handle it
> later. The trade-off that this patch makes is that
>
>    $ perf list --foo
>
> will not error out like it used to.

Why not make raw_dump a proper argument?


--------------080000000604010104080007
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-perf-list-Fix-raw-dump-arg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-perf-list-Fix-raw-dump-arg.patch"

>From b4444edaeffba7ebc459ee1b2cbe4f9cbd057476 Mon Sep 17 00:00:00 2001
From: David Ahern <dsahern@gmail.com>
Date: Wed, 11 Dec 2013 14:00:20 -0700
Subject: [PATCH] perf list: Fix raw-dump arg

Ramkumar reported that perf list --raw-dump was broken by 44d742e.
Fix by making raw-dump a proper argument.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-list.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e38f21..b553d0c4ca82 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -19,7 +19,9 @@
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
+	bool raw_dump = false;
 	const struct option list_options[] = {
+		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "raw dump for completion"),
 		OPT_END()
 	};
 	const char * const list_usage[] = {
@@ -36,6 +38,10 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 		print_events(NULL, false);
 		return 0;
 	}
+	if (raw_dump) {
+		print_events(NULL, true);
+		return 0;
+	}
 
 	for (i = 0; i < argc; ++i) {
 		if (i)
@@ -53,8 +59,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			print_hwcache_events(NULL, false);
 		else if (strcmp(argv[i], "pmu") == 0)
 			print_pmu_events(NULL, false);
-		else if (strcmp(argv[i], "--raw-dump") == 0)
-			print_events(NULL, true);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
-- 
1.8.3.4 (Apple Git-47)


--------------080000000604010104080007--
