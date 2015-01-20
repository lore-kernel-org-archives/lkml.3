Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbbATRCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:02:20 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:59822 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbbATRCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:02:15 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 20 Jan 2015 12:03:19 -0500 (EST)
To: linux-kernel@vger.kernel.org
cc: Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: perf: behavior of poll() changed in 3.18
Message-ID: <alpine.DEB.2.11.1501201155380.18043@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Some of my code that used poll() on a perf_event fd broke sometime between 
3.17 and current.  (My perf_event_test validation testsuite caught this
too but I haven't been running it as regularly as I should).

I bisected this to:

	commit 179033b3e064d2cd3f5f9945e76b0a0f0fbf4883
	Author: Jiri Olsa <jolsa@kernel.org>
	Date:   Thu Aug 7 11:48:26 2014 -0400

	perf: Add PERF_EVENT_STATE_EXIT state for events with exited task


Before, when polling, my code would get a
	result=0/WIFEXITED()
return when a child with events being polled exited.

Now instead I get a 
	result=1/POLLHUP
return.

Needless to say this broke my code.  Is there a reason this change was 
made?

Vince

