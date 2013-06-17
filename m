Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3FQQon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:44:43 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:47351 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3FQQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:44:42 -0400
Date: Mon, 17 Jun 2013 18:44:27 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Markos Chandras <markos.chandras@imgtec.com>
Cc: linux-mips@linux-mips.org, sibyte-users@bitmover.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/7] MIPS: sibyte: Add missing sched.h header
Message-ID: <20130617164427.GE10408@linux-mips.org>
References: <1371477641-7989-1-git-send-email-markos.chandras@imgtec.com>
 <1371477641-7989-4-git-send-email-markos.chandras@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371477641-7989-4-git-send-email-markos.chandras@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 03:00:37PM +0100, Markos Chandras wrote:

> It's needed for the TASK_INTERRUPTIBLE definition.
> 
> Fixes the following build problem:
> arch/mips/sibyte/common/sb_tbprof.c:235:4: error: 'TASK_INTERRUPTIBLE'
> undeclared (first use in this function)

Ideally sched.h should be included into the actual user of
TASK_INTERRUPTIBLE, the wake_up_interruptible macro in <linux/wait.h> but
that seems way too risky that close to a release.

  Ralf
