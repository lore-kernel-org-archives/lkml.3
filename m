Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab3KME6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 23:58:44 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62017 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab3KME6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 23:58:37 -0500
Message-ID: <528306F5.8050307@gmail.com>
Date: Tue, 12 Nov 2013 21:58:29 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: perf tip: fails to convert comm
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung and Frederic:

If you recall I mentioned noting a problem with the callchain series 
showing comm's. Well, it fails on acme's perf/core. git bisect points to:

$ git bisect bad
4dfced359fbc719a35527416f1b4b3999647f68b is the first bad commit
commit 4dfced359fbc719a35527416f1b4b3999647f68b
Author: Namhyung Kim <namhyung.kim@lge.com>
Date:   Fri Sep 13 16:28:57 2013 +0900

     perf tools: Get current comm instead of last one

     At insert time, a hist entry should reference comm at the time 
otherwise
     it'll get the last comm anyway.


How to re-create:

Start point is tools/perf directory for 3.12 (Linus tree):
   $ perf sched record -o /tmp/perf.data -g -- make -j 16
   $ perf script -i /tmp/perf.data > /tmp/1

cd to Arnaldo's tree, make perf and use it to create /tmp/2:
   $ perf script -i /tmp/perf.data > /tmp/1
   $ diff -U3 /tmp/1 /tmp/2 | less

You'll see a number of comm's showing as :<pid> instead of make, etc.

David
