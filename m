Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3JKHK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:10:28 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47094 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3JKHK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:10:27 -0400
Subject: [PATCH -tip  0/2] Perf Probe updates
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 11 Oct 2013 16:10:20 +0900
Message-ID: <20131011071020.15557.20050.stgit@udc4-manage.rcp.hitachi.co.jp>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a cuple of patches to update perf probe for supporting
meta arguments for local variables.

With this updates we can use $vars as a probe event argument
for all available local variables at that address.

And also, I've found an issue about variable location.
With -fentry, since the variable available address range has
skipped the mcount call instruction at the function entry,
`perf probe --vars a_function_with_mcount` always failed to
find available variables. This also disabled $vars at the
function entry which is for tracing function parameters.

The second patch tries to fix this issue by searching
variables from the entry address of the function. Note
that this works only for function parameters (not for auto
varibales, because those are not initialized yet at the
function entry).

Thank you,

---

Masami Hiramatsu (2):
      perf probe: Support "$vars" meta argument syntax for local variables
      perf probe: Find fentry mcount fuzzed parameter location


 tools/perf/util/probe-event.c  |    1 
 tools/perf/util/probe-finder.c |  133 +++++++++++++++++++++++++++++++++++-----
 tools/perf/util/probe-finder.h |    1 
 3 files changed, 119 insertions(+), 16 deletions(-)

-- 


