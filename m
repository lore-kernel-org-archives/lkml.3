Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaDVTxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:53:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:40755 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751534AbaDVTxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:53:05 -0400
Message-Id: <20140422194824.319892442@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 22 Apr 2014 15:48:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] tools lib traceevent: Options for plugins
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace-cmd has a way to set options for plugins, via the command
line parameter. For example, you can add or remove the parent
from being printed in function tracing by adding:

  -O parent=1
  -O parent=0

This is passed later to the plugin in. But the plugin itself requires
registering to the application what options it supplies.

This is a three patch series. The first is to set a flag in pevent
that would prevent plugins from being loaded. This can be supplied
by the command line as well to produce the old "raw" events.

The second patch adds the infrastructure to let plugins have options.

The third patch adds the options "parent" and "indent" to the
function plugin. The indent option lets the user print functions
with or without indenting by their parents.

All that needs to be done now is to add the options to the perf
command line. Namhyung? ;-)

-- Steve


Steven Rostedt (Red Hat) (3):
      tools lib traceevent: Add flag to not load event plugins
      tools lib traceevent: Add options to plugins
      tools lib traceevent: Add options to function plugin

----
 tools/lib/traceevent/event-parse.h     |  16 ++-
 tools/lib/traceevent/event-plugin.c    | 204 ++++++++++++++++++++++++++++++++-
 tools/lib/traceevent/plugin_function.c |  43 ++++++-
 3 files changed, 253 insertions(+), 10 deletions(-)
