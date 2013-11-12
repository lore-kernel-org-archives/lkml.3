Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab3KLX0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:26:21 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:62589 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3KLX0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:26:14 -0500
Date: Wed, 13 Nov 2013 00:26:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: perf top -u <uid> does not seem to be working
Message-ID: <20131112232609.GA31474@gmail.com>
References: <20131112232249.GA31384@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112232249.GA31384@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


an unrelated bug is a missing newline if the 'uid' is invalid:

  hubble:~> perf top --stdio -u help
  Error:
  Invalid User: helphubble:~> 

Fixed by the patch below.

  comet:~/tip/tools/perf> perf top --stdio -u help
  Error:
  Invalid User: help
  comet:~/tip/tools/perf> 

Signed-off-by: Ingo Molnar <mingo@kernel.org>

 tools/perf/builtin-top.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b8f8e29..71e6402 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1172,7 +1172,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	status = target__validate(target);
 	if (status) {
 		target__strerror(target, status, errbuf, BUFSIZ);
-		ui__warning("%s", errbuf);
+		ui__warning("%s\n", errbuf);
 	}
 
 	status = target__parse_uid(target);
@@ -1180,7 +1180,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		int saved_errno = errno;
 
 		target__strerror(target, status, errbuf, BUFSIZ);
-		ui__error("%s", errbuf);
+		ui__error("%s\n", errbuf);
 
 		status = -saved_errno;
 		goto out_delete_evlist;

