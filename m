Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3A1S0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:26:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3A1S0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:26:23 -0500
Date: Mon, 28 Jan 2013 19:24:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] uprobes: kill uprobe_trace_consumer and other cleanups
Message-ID: <20130128182423.GA18273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of
"[PATCH 0/4] uprobes: Teach debug/tracing/uprobe_events to do the filtering"
I sent yesterday.

I tried to test that series, seems to work...

This one tries to cleanup the code. No functional changes. Almost untested
so far, but please review.

Since I had to look at this code, I simply can't resist. uprobe_trace_consumer
complicates the code for no reason and imho should die.

Oleg.

 kernel/trace/trace_uprobe.c |  146 ++++++++++++++++++-------------------------
 1 files changed, 62 insertions(+), 84 deletions(-)

