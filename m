Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaBJPg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:36:57 -0500
Received: from hofr.at ([212.69.189.236]:43821 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaBJPgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:36:55 -0500
Date: Mon, 10 Feb 2014 16:36:53 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-rt-users@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: [PATCH RT 0/5] preempt_disable/enable -> migrate_disable/enable
	pushdown proposals
Message-ID: <20140210153653.GA20017@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



a small series of preempt_disable/enable -> migrate_disable/enable pushdown 
proposals

In mainline a number of preempt_disable/enable are actually topology control 
and not actual concurrency control - these cases can be pushed down to a 
preemptible migrate_disable/enable. 

This little series contains a few pushdowns from preempt_disable to 
migrate_disable where code pattern scans using cocci scripts suggested this 
to be possible. The cases detected were then reviewed and tested with the 
migrate_disable/enable respectively with the preempt_disable/enable 
completely removed in one case.

Testing was done but is of very limited use for locking/migration related
issues, so a review of the code analysis/rational is requested along with
additional testing.

thx!
hofrat
