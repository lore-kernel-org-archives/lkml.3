Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab3C1ErC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:47:02 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:58835 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3C1ErA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:47:00 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, rajagopal.venkat@linaro.org,
        davidb@codeaurora.org, ulf.hansson@linaro.org,
        laurent.pinchart@ideasonboard.com, tglx@linutronix.de,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v5 0/2] reentrancy in the common clk framework
Date: Wed, 27 Mar 2013 21:45:56 -0700
Message-Id: <1364445958-2999-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fifth attempt at allowing calls to the clk api to reenter splits
the last patch into two parts.  The first patch abstracts out the
locking details into some helper functions and converts all of the
direct calls to the mutex and spinlock api to use these helpers.

The second patch introduces the reentrancy logic into these helper
functions.  Fundamentally the reentrancy logic hasn't changed since v4,
but fixing casting bugs, removing unnecessary barriers and better design
& beautification separate this approach from the last one.

Changes tested on top of the latest clk-next branch with an OMAP4430
Panda board.

Mike Turquette (2):
  clk: abstract locking out into helper functions
  clk: allow reentrant calls into the clk framework

 drivers/clk/clk.c |  136 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 98 insertions(+), 38 deletions(-)

-- 
1.7.10.4

