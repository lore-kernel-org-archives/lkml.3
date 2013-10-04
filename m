Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab3JDMxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:53:31 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46676 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3JDMx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:53:28 -0400
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Daniel Mack <zonque@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org
Subject: [PATCH v2 2/2] input: rotary-encoder: Add 'on-each-step' to binding documentation
Date: Fri,  4 Oct 2013 09:53:23 -0300
Message-Id: <1380891203-17617-3-git-send-email-ezequiel@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380891203-17617-1-git-send-email-ezequiel@vanguardiasur.com.ar>
References: <1380891203-17617-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver now supports a new mode to handle the interruptions generated
by the device: on this new mode an input event is generated on each step
(i.e. on each IRQ). Therefore, add a new DT property, to select the
mode: 'rotary-encoder,on-each-step'.

Cc: Daniel Mack <zonque@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
I'm not at all happy with this DT binding as it's way to customized
for the current driver. For instance, if we want to support mapping
key events (or better arbitrary linux-input event types) it seems
there's no easy way to fix the binding.

Maybe a better way of handling the different 'modes' is through
compatible strings?

I'm not really sure, so I hope the DT guys have some comment on this.

 Documentation/devicetree/bindings/input/rotary-encoder.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/input/rotary-encoder.txt b/Documentation/devicetree/bindings/input/rotary-encoder.txt
index 3315495..b89e38d 100644
--- a/Documentation/devicetree/bindings/input/rotary-encoder.txt
+++ b/Documentation/devicetree/bindings/input/rotary-encoder.txt
@@ -15,6 +15,7 @@ Optional properties:
 - rotary-encoder,rollover: Automatic rollove when the rotary value becomes
   greater than the specified steps or smaller than 0. For absolute axis only.
 - rotary-encoder,half-period: Makes the driver work on half-period mode.
+- rotary-encoder,on-each-step: Makes the driver send an event on each step.
 
 See Documentation/input/rotary-encoder.txt for more information.
 
-- 
1.8.1.5

