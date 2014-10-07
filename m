Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaJGJvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:51:23 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:54147 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbaJGJut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:50:49 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 4/4] Input: pmic8xxx-keypad - update DT bindings documentation
Date: Tue,  7 Oct 2014 12:50:48 +0300
Message-Id: <1412675448-11990-5-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
References: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect dimensions for 'debonce' and 'scan-delay' times.
Now they represent what driver really expect. Add possible
time quants for 'debonce', 'scan-delay' and 'row-hold' times.
Update bindings example.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt b/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
index 2b60f8a..df5e2a1 100644
--- a/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
+++ b/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
@@ -54,20 +54,23 @@ PROPERTIES
 - debounce:
 	Usage: optional
 	Value type: <u32>
-	Definition: time in microseconds that key must be pressed or release
+	Definition: time in miliseconds that key must be pressed or release
 		    for key sense interrupt to trigger.
+		    Possible values: 5, 10, 15, 20.
 
 - scan-delay:
 	Usage: optional
 	Value type: <u32>
-	Definition: time in microseconds to pause between successive scans
+	Definition: time in miliseconds to pause between successive scans
 		    of the matrix array.
+		    Possible values: 1, 2, 4, 8, 16, 32, 64, 128.
 
 - row-hold:
 	Usage: optional
 	Value type: <u32>
 	Definition: time in nanoseconds to pause between scans of each row in
 		    the matrix array.
+		    Possible values: 30500, 61000, 122000.
 
 EXAMPLE
 
@@ -86,5 +89,5 @@ EXAMPLE
 		keypad,num-columns = <5>;
 		debounce = <15>;
 		scan-delay = <32>;
-		row-hold = <91500>;
+		row-hold = <61000>;
 	};
-- 
1.9.1

