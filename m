Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab3CFLSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:18:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:42490 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab3CFLSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:18:35 -0500
Message-Id: <20130306111351.883117670@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Mar 2013 11:18:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Arjan van de Veen <arjan@infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>
Subject: [patch 0/7] tick: Optimize broadcast handling and prevent expiry ping
 pong
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason decoded a problem related to the broadcast timer mode. The
reprogramming of the cpu local timer causes a huge number of
retries. Also there is a situation where the CPU which does not handle
the broadcast timer interrupt exits and reenters broadcast mode before
the broadcast interrupt got handled by another CPU. This can lead to
an interesting ping pong of the broadcast and the cpu local timer
code.

This series addresses these problems. The first two patches convert
the broadcast code to proper cpumask_var_t instead of adding more
bitmaps later.

The rest of the series is adopted from the quick patches which I
posted earlier while discussing the issue with Jason et. al.

Please give it a proper testing on your affected hardware.

Thanks,

	tglx


