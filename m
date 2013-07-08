Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3GHPSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:18:40 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:51955 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3GHPSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:18:39 -0400
Date: Mon, 8 Jul 2013 11:24:18 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: perf: more ABI breakage
Message-ID: <alpine.DEB.2.10.1307081115350.2281@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I guess I should have been noisier about this at the time.

Linux 3.9 came with commit
   e259514eef764a5286873618e34c560ecb6cff13
that enabled AMD fam15h Northbridge support, by exposing the events as 
part of the core CPU.

Then Linux 3.10 changed this with
   c43ca5091a374c1f6778bd7e4a39a5a10735a917
and split them out as a separate PMU.

This of course breaks libpfm4 and thus PAPI, and so now that 3.10 has come 
out we've had multiple people complaining about this on the PAPI lists (I 
can never get them to come complain here, which is why I always look like 
the lone whiner in these cases).

So can perf_event just break the ABI with impunity?

How many kernel releases do we need to wait before we implement features?

There's not really even a good backwards-compatible fix for this issue, as 
PAPI presents core-CPU events and uncore-CPU events through different 
interfaces.

Vince
