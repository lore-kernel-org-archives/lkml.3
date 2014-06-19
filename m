Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965851AbaFSVek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:34:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:55662 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845AbaFSVej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:39 -0400
Message-Id: <20140619212606.431750473@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 00/13] irqchip: spear_shirq: Cleanup the bitrot
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is broken for spear320 since commit 80515a5a(ARM: SPEAr3xx:
shirq: simplify and move the shared irq multiplexor to DT). Clearly
never tested on spear320.

Aside of that it's an unreadable overengineered trainwreck with lots
of obscure "functionality". 

Make it work and clean it up.

Thanks,

	tglx
---
 include/linux/irqchip/spear-shirq.h |   64 -------
 linux/drivers/irqchip/spear-shirq.c |  306 ++++++++++++++++--------------------
 2 files changed, 138 insertions(+), 232 deletions(-)



