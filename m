Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaDWW6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:58:04 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:55410 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaDWW6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:58:00 -0400
From: Rob Herring <robherring2@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        thierry.reding@gmail.com, Rob Herring <robh@kernel.org>
Subject: [PATCH 0/2] DT irq deferred probe support
Date: Wed, 23 Apr 2014 17:57:39 -0500
Message-Id: <1398293861-7682-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

This is atleast the 4th attempt to fix a long standing issue with DT 
irq resolution needing to support deferred probe when irq parent is not 
yet initialized. This version implements Russell King's suggestion to do 
irq resolution when platform_get_irq is called. 

Tony, I squashed your warning fix (dropping the other part) and stole 
much of your commit message. Let me know if you have any issues with 
that.

Rob

Rob Herring (2):
  of: selftest: add deferred probe interrupt test
  of/irq: do irq resolution in platform_get_irq

 drivers/base/platform.c                        |  7 +++++-
 drivers/of/irq.c                               | 26 +++++++++++++++++++++
 drivers/of/platform.c                          |  4 +++-
 drivers/of/selftest.c                          | 32 ++++++++++++++++++++++++++
 drivers/of/testcase-data/tests-interrupts.dtsi | 12 ++++++++++
 include/linux/of_irq.h                         |  7 +++++-
 6 files changed, 85 insertions(+), 3 deletions(-)

-- 
1.9.1

