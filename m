Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaFWEdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 00:33:16 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:2661 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaFWEdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 00:33:14 -0400
Message-ID: <1403497988.2377.21.camel@j-VirtualBox>
Subject: Re: [PATCH v2] sched: Fast idling of CPU when system is partially
 loaded
From: Jason Low <jason.low2@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Date: Sun, 22 Jun 2014 21:33:08 -0700
In-Reply-To: <1402948127.2970.578.camel@schen9-DESK>
References: <1402948127.2970.578.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 12:48 -0700, Tim Chen wrote:

> Thanks to the review from Jason and Peter.  I've moved the check
> of whether load balance is required into fair.c's idle_balance.
> 
> When a system is lightly loaded (i.e. no more than 1 job per cpu),
> attempt to pull job to a cpu before putting it to idle is unnecessary and
> can be skipped.  This patch adds an indicator so the scheduler can know
> when there's no more than 1 active job is on any CPU in the system to
> skip needless job pulls.

> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Acked-by: Jason Low <jason.low2@hp.com>

This change would address one of the main issues I've also been seeing
on my test machines with idle_balance where most of the
find_busiest_group overhead is not useful due to that issue with no
tasks to move.

