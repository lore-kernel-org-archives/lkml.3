Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaDYX42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:56:28 -0400
Received: from ring0.de ([5.45.105.125]:53121 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaDYX40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:56:26 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 0/5] tsc2005 DT binding
Date: Sat, 26 Apr 2014 01:56:14 +0200
Message-Id: <1398470179-20880-1-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This adds device tree support for the tsc2005 touchscreen
controller, which is currently only used by the Nokia N900
board.

The patch does not update the reset pin handling for platform
data based probe to avoid merge conflicts. The n900 platform
code will be removed in the near future (3.16?) and the driver
can be simplified once that has happened.

Changes since v2 [0]:
 * rename "ti,x-plate-resistance" to "ti,x-plate-ohms", so that
   the same property name is used for tsc2005 and tsc2007
 * document "x-size" and "y-size" as deprecated form of
   touchscreen-size-x and touchscreen-size-y
 * add documentation for "touchscreen-inverted-x" and
   "touchscreen-inverted-y" to the common touchscreen binding
   and mark "x-invert" and "y-invert" as deprecated.
 * add units to the property descriptions in the common
   touchscreen binding Documentation
 * document "moving-threshold" as deprecated form of
   "touchscreen-fuzz-x" and "touchscreen-fuzz-y" combination
 * document "contact-threshold" as deprecated form of
   "touchscreen-fuzz-pressure"

[0] https://lkml.org/lkml/2014/4/5/103

-- Sebastian

Sebastian Reichel (5):
  Input: add common DT binding for touchscreens
  Input: tsc2005: use dev_err for error messages
  Input: tsc2005: convert driver to use devm_*
  Input: tsc2005: add DT support
  Documentation: dt: Document TSC2005 DT binding

 .../bindings/input/touchscreen/touchscreen.txt     |  27 +++++
 .../bindings/input/touchscreen/tsc2005.txt         |  39 +++++++
 drivers/input/input.c                              |  34 ++++++
 drivers/input/touchscreen/tsc2005.c                | 130 ++++++++++++++-------
 include/linux/input.h                              |   8 ++
 5 files changed, 197 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/tsc2005.txt

-- 
1.9.2

