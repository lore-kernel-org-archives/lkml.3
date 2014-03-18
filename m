Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbaCRRTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:19:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:55704 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbaCRRS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:18:59 -0400
Message-Id: <20140318171007.528610837@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 18 Mar 2014 17:19:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [patch 00/12] can: c_can: Fix a series of serious bugs and improve
 the performance
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, I'm really grumpy as hell.

This is the worst driver I looked at in the last 10 years. And that's
an achievement.

The driver is full of serious bugs:

    - Two HW init routines are not spec compliant.

    - Completely defective message buffer handling in several ways
      That leads to interrupt storms and complete lockups.

    - Complete lack of SMP awareness

What's amazing is that people "optimize" and "fix" the driver over and
over, but nobody bothered to understand the manual and repair the code
for real.

The series fixes _ALL_ bugs which I found so far, but I'm sure there
are more issues burried in that unreadable mess. I'm just not able to
trigger them.

The last few patches add real performance improvements by removing a
gazillion of pointless hardware operations.

Thanks,

	tglx

--------------->

 c_can.c          |  311 ++++++++++++++++++++++++++++++-------------------------
 c_can.h          |   29 +++++
 c_can_platform.c |   48 ++++++--
 3 files changed, 241 insertions(+), 147 deletions(-)



