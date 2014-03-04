Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbaCDK20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:28:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:9852 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954AbaCDK2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:28:18 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-ed-5315aac1cfdd
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Thomas Abraham <ta.omasab@gmail.com>,
        thomas.ab@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC v3 5/5] cpufreq:LAB:dts:trats2: Add DTS nodes for LAB governor
Date: Tue, 04 Mar 2014 11:27:32 +0100
Message-id: <1393928852-22725-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd2Dq0SDDaa3s1tsnLGe1eJp0w92
	i86zT5gt3jzitnjzcDOjxabH11gtLu+aw2bxufcIo8WM8/uYLG43rmCzOHP6EqvF+hmvWSw2
	T9jIZtGxjNFi41cPB36PnbPusnvcubaHzWPzknqPddPeMntsudrO4tG3ZRWjx+dNcgHsUVw2
	Kak5mWWpRfp2CVwZ3ROWsBTs5a241DyDpYHxCmcXIyeHhICJxIl/x5ggbDGJC/fWs3UxcnEI
	CSxilDiyvJkFwulikrj0+gQrSBWbgJ7E57tPwTpEBEIljk79yg5SxCxwhkXi7YvdYEXCAj4S
	DyftZwexWQRUJfrmP2UDsXkF3CR6j15lgVinKNH9bAJYnFPAXeL4imZmiG2tjBKXd95gmsDI
	u4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcNg+k9rBuLLB4hCjAAejEg/vjGkiwUKs
	iWXFlbmHGCU4mJVEeBUXigYL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpa
	kFoEk2Xi4JRqYFwdyhDgHh5mt3sSg+b+0uf77lZt33DuchfD9ynrXAueFua0sInI9Vy/v9b/
	wZQrRy/MfOgj8d3Mt+Pu7Qa5hG/zu9WuPvmi9UzIOtWhZom7DmNRTcl206qwfs+jC+w+tlo+
	ia8KMxe/pzwjcUPzbzse1flLJ2rXhFwxsTqw/x5r+URWtZYXxUosxRmJhlrMRcWJAMP39MFX	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds LAB attributes to proper CPU0 node.
The lab-num-of-states attribute shows how many compartments will be used.
The LAB code is prepared to be more fine grained.

The lab-ctrl-freq defines how the LAB governor will be controlled:
	- 0xFFFFFFFE 		- use the minimal frequency
	- 0xFFFFFFFF 		- enable boost
	- non zero 		- set the frequency specified
	- zero		- use ondemand to specify output frequency

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 4f851cc..9eeeb38 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -511,6 +511,35 @@
 		};
 	};
 
+	cpus {
+		cpu@0 {
+			compatible = "arm,cortex-a9";
+			device_type = "cpu";
+			lab-num-of-states = <5>;
+			lab-ctrl-freq = < 0          0          0          1300000    1200000
+					  0          0          0          0          1300000
+					  0          0          0          0          0xFFFFFFFF
+					  0          0          0          0xFFFFFFFF 0xFFFFFFFF
+					  0xFFFFFFFE 0xFFFFFFFE 0xFFFFFFFE 0xFFFFFFFE 0xFFFFFFFE
+				>;
+		};
+
+		cpu@1 {
+			compatible = "arm,cortex-a9";
+			device_type = "cpu";
+		};
+
+		cpu@2 {
+			compatible = "arm,cortex-a9";
+			device_type = "cpu";
+		};
+
+		cpu@3 {
+			compatible = "arm,cortex-a9";
+			device_type = "cpu";
+		};
+	};
+
 	camera {
 		pinctrl-0 = <&cam_port_b_clk_active>;
 		pinctrl-names = "default";
-- 
1.7.10.4

