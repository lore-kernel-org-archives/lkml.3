Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbaGCVnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:43:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:53685 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbaGCVnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:43:14 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [RFC PATCHES 0/7] Add support for showing headers in the hist browser.
Date: Thu,  3 Jul 2014 18:42:53 -0300
Message-Id: <1404423780-24026-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

	As you guys know this allows showing the columns headers on the hists
browsers, used in 'perf top' and 'perf report'. So, to test it, just apply,
fire one of those tools and press 'H' repeatedly.

	Please take a look, this should be mostly equivalent to your patchkit in
intent, but fixes some problems and is more consistent with how I first designed
the ui_browser code.

	Please let me know if you are ok with it and if I can have your
Acked-by and perhaps Tested-by tags for the code I wrote.

	Namhyung, since you reviewed the previous patchkit, I'd like to know
if I can keep the acked-by and perhaps a tested-by too. This should address the
problems that Jiri pointed out in our private conversation.

Thanks,

- Arnaldo

Arnaldo Carvalho de Melo (5):
  perf ui browser: Add ->rows to disambiguate from ->height
  perf ui browser: Allow overriding refresh_dimensions method
  perf hists browser: Introduce gotorc method
  perf hists browser: Override ui_browser refresh_dimensions method
  perf hists browser: Add support for showing columns header

Jiri Olsa (2):
  perf hists browser: Display columns header text on 'H' press
  perf hists browser: Add ui.show-headers config file option

 tools/perf/ui/browser.c        |  37 ++++++------
 tools/perf/ui/browser.h        |   3 +-
 tools/perf/ui/browsers/hists.c | 128 +++++++++++++++++++++++++++++++++++------
 tools/perf/util/config.c       |  13 +++++
 tools/perf/util/symbol.c       |   1 +
 tools/perf/util/symbol.h       |   3 +-
 6 files changed, 149 insertions(+), 36 deletions(-)

-- 
1.9.3

