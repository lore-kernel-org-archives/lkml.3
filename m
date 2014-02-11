Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaBKKT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:19:58 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.137]:61816 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbaBKKTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:19:55 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-12.tower-180.messagelabs.com!1392113934!26297695!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1392044599.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Tue, 11 Feb 2014 10:18:52 +0000
Subject: [PATCH 0/2] onkey/rtc: da9055: Remove conflicting use of regmap_irq_get_virq()
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Alessandro Zummo <a.zummo@towertech.it>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set removes the use of regmap_irq_get_virq() in driver probes for
da9055 (in particular RTC and ONKEY) which was conflicting with use of
platform_get_irq_byname(). platform_get_irq_byname() already returns the VIRQ
number due to MFD core translation so using regmap_irq_get_virq() on that
returned value results in an incorrect IRQ being requested. The driver probes
then fail because of this.

Adam Thomson (2):
  onkey: da9055: Remove use of regmap_irq_get_virq()
  rtc: da9055: Remove use of regmap_irq_get_virq()

 drivers/input/misc/da9055_onkey.c |    1 -
 drivers/rtc/rtc-da9055.c          |    4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

