Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab3EWIjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:39:33 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:36344 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3EWIj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:39:29 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Nelson <Robert.Nelson@digikey.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 0/5] rtc-at91rm9200: add shadow interrupt mask
Date: Thu, 23 May 2013 10:38:50 +0200
Message-Id: <1369298335-24597-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1364983415-20298-1-git-send-email-jhovold@gmail.com>
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update of the shadow-interrupt-mask series against v3.10-rc2.

I guess we need Atmel to confirm that all sam9x5 SoCs are indeed
affected. If not, then some probing mechanism as the one Doug suggested
could be implemented on top of (a subset of) these patches. What do you
say, Nicolas?

Note that the first patch (adding a missing OF compile guard) could be
applied straight away.

Thanks,
Johan


v3:
 - rebase against v3.10-rc2
 - remove some comments

v2:
 - rebase on top of DT-support patch by Joachim Eastwood
 - add missing brace in DT-id table


Johan Hovold (5):
  rtc-at91rm9200: add match-table compile guard
  rtc-at91rm9200: add configuration support
  rtc-at91rm9200: refactor interrupt-register handling
  rtc-at91rm9200: add shadow interrupt mask
  rtc-at91rm9200: use shadow IMR on at91sam9x5

 .../bindings/rtc/atmel,at91rm9200-rtc.txt          |   2 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   2 +-
 drivers/rtc/rtc-at91rm9200.c                       | 131 +++++++++++++++++----
 3 files changed, 113 insertions(+), 22 deletions(-)

-- 
1.8.2.1

