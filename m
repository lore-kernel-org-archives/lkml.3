Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab3LTWJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 17:09:11 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:48136 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3LTWJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 17:09:06 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: [RFC 1/2] dt: binding: add clock-N-frequency to common clock bindings
Date: Fri, 20 Dec 2013 22:08:46 +0000
Message-Id: <1387577327-5007-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387577327-5007-1-git-send-email-james.hogan@imgtec.com>
References: <1387577327-5007-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a property "clock-N-frequency" to the clock consumer bindings to
specify the frequency that a clock should be configured to when it is
made use of. N is the index of a clock specifier in the clocks property,
starting at 0.

This avoids the need to add clock-frequency properties to individual
device bindings or modify drivers to set the frequency of clocks to that
requested in device tree. Instead the driver can just read the rate of
the clock as if it was fixed.

This is aimed at devices where it's difficult for drivers to determine
what a clock should be set to, and either there is a recommended
frequency for the particular system or a chosen frequency for the
particular application of the system (which makes it essentially
configuration data).

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree@vger.kernel.org
Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/devicetree/bindings/clock/clock-bindings.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
index eb65d41..e8bca1a 100644
--- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
+++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
@@ -60,6 +60,9 @@ clock-names:	List of clock input name strings sorted in the same
 clock-ranges:	Empty property indicating that child nodes can inherit named
 		clocks from this node. Useful for bus nodes to provide a
 		clock to their children.
+clock-N-frequency: Single cell specifying the frequency in HZ to set the N'th
+		clock to when it is used. N=0 corresponds to the first clock
+		specifier in the clocks property.
 
 For example:
 
-- 
1.8.3.2

