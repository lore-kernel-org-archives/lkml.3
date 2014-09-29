Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaI2Qjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:39:39 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:40861 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbaI2Qjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:39:37 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 09:39:16 -0700
Message-ID: <CALCETrU3nNvG6+-7iScYT8LDRFnq8kYnpK0cdW1bgW5O4EGrUg@mail.gmail.com>
Subject: Tightening up rdpmc permissions?
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was surprised to notice that, by default, every task has permission
to use rdpmc.  seccomp cannot work around this.  This leaks
information, although the information leaked is of dubious and
variable value to an attacker.  It also renders the PR_TSC_SEGV
mechanism mostly useless.

Would it make sense to restrict rdpmc to tasks that are in mms that
have a perf_event mapping?  After all, unless I misunderstand
something, user code can't reliably use rdpmc unless they've mapped a
perf_event object to check the rdpmc bit and figure out what ecx value
to use.

I think that this could be implemented with very little overhead,
especially if combined with the existing CR4_TSD code and if that code
were taught to avoid reading cr4.

--Andy
