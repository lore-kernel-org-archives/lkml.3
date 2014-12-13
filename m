Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaLMANp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 19:13:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:37720 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaLMANo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 19:13:44 -0500
Date: Sat, 13 Dec 2014 01:13:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] clk: Really fix deadlock with mmap_sem
In-Reply-To: <1418425456-19364-1-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.DEB.2.11.1412130053480.16494@nanos>
References: <1418425456-19364-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2014, Stephen Boyd wrote:

> Commit 6314b6796e3c (clk: Don't hold prepare_lock across debugfs
> creation, 2014-09-04) forgot to update one place where we hold
> the prepare_lock while creating debugfs directories. This means
> we still have the chance of a deadlock that the commit was trying
> to fix. Actually fix it by moving the debugfs creation outside
> the prepare_lock.
> 
> Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Fixes: 6314b6796e3c "clk: Don't hold prepare_lock across debugfs creation"
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

> +	lockdep_assert_held(clk_debug_lock);

That change is not mentioned in the changelog and seems to be
unrelated to the issue at hand.

Other than that:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

