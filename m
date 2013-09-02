Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab3IBVhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:37:36 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59467 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758943Ab3IBVhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:37:35 -0400
Message-ID: <5225051C.3030608@gmail.com>
Date: Mon, 02 Sep 2013 15:37:32 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: latest perf code fails to parse existing data file
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo/Adrian:

Latest acme core tree fails to parse an existing data file:

$ perf trace -i perf.data
0x16b8 [0x40]: failed to process type: 1
Failed to process events, error -22

git bisect traced it to:
$ git bisect bad
75562573bab35b129cfd342fc2bcf89da84a6644 is the first bad commit
commit 75562573bab35b129cfd342fc2bcf89da84a6644
Author: Adrian Hunter <adrian.hunter@intel.com>
Date:   Tue Aug 27 11:23:09 2013 +0300

     perf tools: Add support for PERF_SAMPLE_IDENTIFIER

     Enable parsing of samples with sample format bit 
PERF_SAMPLE_IDENTIFIER.
     In addition, if the kernel supports it, prefer it to selecting
     PERF_SAMPLE_ID thereby allowing non-matching sample types.

     Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
     Cc: David Ahern <dsahern@gmail.com>
     Cc: Frederic Weisbecker <fweisbec@gmail.com>
     Cc: Ingo Molnar <mingo@kernel.org>
     Cc: Jiri Olsa <jolsa@redhat.com>
     Cc: Mike Galbraith <efault@gmx.de>
     Cc: Namhyung Kim <namhyung@gmail.com>
     Cc: Paul Mackerras <paulus@samba.org>
     Cc: Peter Zijlstra <peterz@infradead.org>
     Cc: Stephane Eranian <eranian@google.com>
     Link: 
http://lkml.kernel.org/r/1377591794-30553-8-git-send-email-adrian.hunter@intel.com
     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

:040000 040000 7df758341904d77c391b90ab6b6bac97324d144a 
93839bad8ab2e6d88d3037f3dc8fd721be5e8870 M	tools


If I revert the patch (and handle the missing __perf_evsel__sample_size 
in the tests code to get it to compile) it works -- file is parsed 
correctly.

David
