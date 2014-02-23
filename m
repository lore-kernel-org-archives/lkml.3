Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaBWXSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:18:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55936 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaBWXR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:17:59 -0500
Date: Mon, 24 Feb 2014 00:17:55 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [patch 09/26] arm: mmp: Remove pointless fiddling with irq
 internals
Message-ID: <20140223231755.GA27579@pengutronix.de>
References: <20140223212703.511977310@linutronix.de>
 <20140223212737.214342433@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140223212737.214342433@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Sun, Feb 23, 2014 at 09:40:13PM -0000, Thomas Gleixner wrote:
> The pm-mmp2 and pm-pxa910 power management related irq_set_wake
> callbacks fiddle pointlessly with the irq actions for no reason except
> for lack of understanding how the wakeup mechanism works.
> 
> On supsend the core disables all interrupts lazily, i.e. it does not
> mask them at the irq controller level. So any interrupt which is
> firing during supsend will mark the corresponding interrupt line as
s/supsend/suspend/ twice
> pending. Just before the core powers down it checks whether there are
> interrupts pending from interrupt lines which are marked as wakeup
> sources and if so it aborts the resume and resends the interrupts.
It's the suspend that is aborted, not the resume.

Other than that your change looks fine.

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
