Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaBDUlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:41:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:49319 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbaBDUls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:41:48 -0500
Date: Tue, 4 Feb 2014 21:41:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 5/7] clocksource/cadence_ttc: Use only one counter
In-Reply-To: <1391466877-28908-6-git-send-email-soren.brinkmann@xilinx.com>
Message-ID: <alpine.DEB.2.02.1402042138480.24986@ionos.tec.linutronix.de>
References: <1391466877-28908-1-git-send-email-soren.brinkmann@xilinx.com> <1391466877-28908-6-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Soren Brinkmann wrote:

> Currently the driver uses two of the three counters the TTC provides to
> implement a clocksource and a clockevent device. By using the TTC's
> match feature we can implement both use cases using a single counter
> only.

Are you entirely sure that this match feature is free of the infamous
HPET match feature issues?

See arch/x86/kernel/hpet.c: hpet_next_event()

If yes, please add a comment. If no ....

Thanks,

	tglx
