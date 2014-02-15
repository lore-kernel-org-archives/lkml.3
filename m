Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaBOAzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 19:55:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:45559 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbaBOAzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 19:55:14 -0500
Message-Id: <20140215002742.507053194@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sat, 15 Feb 2014 00:55:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        linux-mmc@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 0/2] genirq: Add functions to avoid driver hackery
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell tricked me to look into the homebrewn kthread hackery of
drivers/mmc. I'm still trying to recover from that.

But it spurred an interesting discussion how to improve things and the
outcome was the following series of patches:

1) Provide means to synchronize only hard irq context

2) Provide means to trigger a threaded irq handler from any context

The main rationale is to cleanup the mess in drivers/mmc and other
places but each of the patches has a justification for itself
exemplified by the drivers/mmc use case, which is explained in detail
in the changelogs of the individual patches.

Russell has a working implementation for sdhci which relies on patch
#1 ready and quite some ideas how to make use of #2 to kill the
sdio_irq kthread hackery.

Thanks,

	tglx



