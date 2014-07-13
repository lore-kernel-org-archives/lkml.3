Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaGMUKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 16:10:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaGMUK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 16:10:27 -0400
Date: Sun, 13 Jul 2014 22:09:45 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 10/11] perf, tools, test: Add test case for alias and
 JSON parsing
Message-ID: <20140713200945.GA1800@krava.redhat.com>
References: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
 <1405123165-22666-11-git-send-email-andi@firstfloor.org>
 <20140712231005.GB29028@krava.redhat.com>
 <20140712234959.GY18735@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140712234959.GY18735@two.firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 01:49:59AM +0200, Andi Kleen wrote:
> > missing the tests/aliases.o file
> > 
> >   AR       libperf.a
> > ar: tests/aliases.o: No such file or directory
> 
> Fixed here (and in git)

got it, would you be ok with following change?
using pr_* instead of fprintf calls..

jirka


---
diff --git a/tools/perf/tests/aliases.c b/tools/perf/tests/aliases.c
index 08a5f01..f315fbc 100644
--- a/tools/perf/tests/aliases.c
+++ b/tools/perf/tests/aliases.c
@@ -25,7 +25,7 @@ static int test__event(const char *pmu, const char *name)
 		 * We only print on failure because common perf setups
 		 * have events that cannot be parsed.
 		 */
-		fprintf(stderr, "invalid or unsupported event: '%s'\n", name);
+		pr_err("invalid or unsupported event: '%s'\n", name);
 		ret = 0;
 		failed++;
 	} else
@@ -42,7 +42,7 @@ int test__aliases(void)
 	/* For now user must manually download */
 	if (0 && system("perf download > /dev/null") < 0) {
 		/* Don't error out for this for now */
-		fprintf(stderr, "perf download failed\n");
+		pr_err("perf download failed\n");
 	}
 
 	evlist = perf_evlist__new();
@@ -50,9 +50,9 @@ int test__aliases(void)
 		return -ENOMEM;
 
 	err = pmu_iterate_events(test__event);
-	fprintf(stderr, " Parsed %d events :", num_events);
+	pr_debug(" Parsed %d events :", num_events);
 	if (failed > 0)
-		pr_debug(" %d events failed", failed);
+		pr_err(" %d events failed", failed);
 	perf_evlist__delete(evlist);
 	return err;
 }
