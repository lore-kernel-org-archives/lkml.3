Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaINNXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:23:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbaINNXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:23:33 -0400
Date: Sun, 14 Sep 2014 15:23:22 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [PATCH V6 0/3] perf tools: pmu event new style format fix
Message-ID: <20140914132322.GB1731@krava.redhat.com>
References: <1410462539-5468-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410462539-5468-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 03:08:56PM -0400, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> There are two types of pmu event stytle formats, "pmu_event_name"
> or "cpu/pmu_event_name/". However, there is a bug on supporting these
> two formats, especially when they mixed with other perf events.
> The patch set intends to fix this issue.
> 
> The patch set has been tested on my haswell.
> Here is the test script I used for this issue.
> (Note: please make sure that your test system supports TSX and
> L1-dcache-loads events. Otherwise, you may want to change the events 
> to other pmu events.)

any chance changing this script to work for everyone?
and make it part of theautomated tests suite?

also how about something like in the attached change

jirka


---
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 5941927a4b7f..2b7c48474761 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1554,6 +1554,15 @@ static int test_pmu_events(void)
 		e.check = test__checkevent_pmu_events;
 
 		ret = test_event(&e);
+		if (ret)
+			break;
+
+		snprintf(name, MAX_NAME, "event=%s", ent->d_name);
+
+		e.name  = name;
+		e.check = test__checkevent_pmu_events;
+
+		ret = test_event(&e);
 #undef MAX_NAME
 	}
