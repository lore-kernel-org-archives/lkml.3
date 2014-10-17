Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaJQIVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:21:19 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:56834 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaJQIVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:21:16 -0400
Date: Fri, 17 Oct 2014 10:21:12 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] s390 vs. kprobes on ftrace
Message-ID: <20141017082112.GB18203@osiris>
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com>
 <543F5C84.7090005@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543F5C84.7090005@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101708-0013-0000-0000-0000017BEB04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:49:56PM +0900, Masami Hiramatsu wrote:
> I'm not sure about s390 nor have the machine, so it is very helpful if you
> give us a command line level test and show us the result with this patch :)
> Fortunately, we already have ftracetest under tools/tesitng/selftest/ftrace/.
> You can add the testcase for checking co-existence of kprobes and ftrace on
> an entry of a function.

FWIW, I was also surprised to see that the order of the ftrace testcases is
not sorted. Maybe you might consider the patch below as well:

>From a659098f63f188e603316e4c4ccb435bf360987a Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Fri, 17 Oct 2014 10:08:35 +0200
Subject: [PATCH] ftracetest: sort testcases

Make sure the order of the executed testcases is always the same.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 tools/testing/selftests/ftrace/ftracetest | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index a8f81c782856..2007a2cde56f 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -37,7 +37,7 @@ abspath() {
 }
 
 find_testcases() { #directory
-  echo `find $1 -name \*.tc`
+  echo `find $1 -name \*.tc | sort`
 }
 
 parse_opts() { # opts
-- 
1.8.5.5

