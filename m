Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaLAX7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:59:19 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:63114 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbaLAX7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:59:16 -0500
Message-ID: <547D00CE.4050705@bergerie>
Date: Tue, 02 Dec 2014 00:59:10 +0100
From: Vincent <vincent.stehle@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Yingjoe Chen <yingjoe.chen@mediatek.com>, linux-next@vger.kernel.org
CC: Marc Zyngier <marc.zyngier@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Linux next: boot on Wandboard broken by gic related change
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

FYI, I noticed that Linux next would not boot anymore on Wandboard i.MX6
quad. This, since next-20141127.

After bisecting for a while, `git bisect run' pointed at this very commit:

  9a1091ef0017c40ab63e7fc0326b2dcfd4dde3a4
  irqchip: gic: Support hierarchy irq domain.

Indeed, reverting this commit on top of Linux next-20141201 repairs the
boot.

I am afraid I cannot debug this, but I would gladly help test patches :)

Best regard,

V.
