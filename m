Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbbAUGgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:36:42 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:43163 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbbAUGgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:36:40 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v3 0/2] clocksource: Conexant CX92755 timers support
Date: Wed, 21 Jan 2015 08:36:27 +0200
Message-Id: <cover.1421821466.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short series adds support for the Conexant CX92755 SoC timers. This SoC is 
part of the Conexant Digicolor series of SoCs.

v3:
   * Split into a separate clocksource series

v2:
   http://article.gmane.org/gmane.linux.kernel/1861850
   http://article.gmane.org/gmane.linux.kernel/1861853

   * Change the timer dt binding, so that the 'reg' property points to the
     first "Agent Communication" register. This should improve the chance of
     reusing this binding for other SoCs in this series.

   * Add the CONTROL() and COUNT() macros to the timer driver to make the code
     clearer.

   * Move arch/arm Kconfig changes from the clocksource driver patch to the
     base arch support patch to reduce dependency between them             

v1:
   http://article.gmane.org/gmane.linux.kernel/1855028
   http://article.gmane.org/gmane.linux.kernel/1855025


Baruch Siach (2):
  clocksource: devicetree: document Conexant Digicolor timer binding
  clocksource: driver for Conexant Digicolor SoC timer

 .../devicetree/bindings/timer/digicolor-timer.txt  |  18 +++
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/timer-digicolor.c              | 164 +++++++++++++++++++++
 3 files changed, 183 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/digicolor-timer.txt
 create mode 100644 drivers/clocksource/timer-digicolor.c

-- 
2.1.4

