Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762531Ab3DCKFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:05:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40081 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760877Ab3DCKEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:04:44 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [RFC v2 0/4] rtc-at91rm9200: add support for at91sam9x5
Date: Wed,  3 Apr 2013 12:03:31 +0200
Message-Id: <1364983415-20298-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1364982862-19759-1-git-send-email-jhovold@gmail.com>
References: <1364982862-19759-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This v2 of my version of the work-around for the buggy hardware
register on sam9x5, based on top of the revert of commit 0ef1594c017
("drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR") and the
DT-support patch in Andrew's queue.

If preferred, the generic configuration support added in the first patch
could easily be reduced to a single flag set based on the
compatible-property matching sam9x5.

Johan

v2
 - rebase on top of DT-support patch by Joachim Eastwood
 - add missing brace in DT-id table

Johan Hovold (4):
  rtc-at91rm9200: add configuration support
  rtc-at91rm9200: refactor interrupt-register handling
  rtc-at91rm9200: add shadow interrupt mask
  rtc-at91rm9200: add support for at91sam9x5

 .../bindings/rtc/atmel,at91rm9200-rtc.txt          |   2 +-
 drivers/rtc/rtc-at91rm9200.c                       | 140 ++++++++++++++++++---
 2 files changed, 121 insertions(+), 21 deletions(-)

-- 
1.8.1.5

