Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaLBOKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:10:13 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39709 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaLBOG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:06:59 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, vincent.guittot@linaro.org, pjt@google.com,
        bsegall@google.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Jon Medhurst <tixy@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC PATCH 05/10] ARM: vexpress: Add CPU clock-frequencies to TC2 device-tree
Date: Tue,  2 Dec 2014 14:06:27 +0000
Message-Id: <1417529192-11579-6-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 02 Dec 2014 14:06:56.0994 (UTC) FILETIME=[3B9EEC20:01D00E39]
X-MC-Unique: 114120214065801601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB2EALDe017010

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

To enable the parsing of clock frequency and cpu efficiency values inside
parse_dt_topology [arch/arm/kernel/topology.c] to scale the relative
capacity of the cpus, this property has to be provided within the cpu
nodes of the dts file.

The patch is a copy of 'ARM: vexpress: Add CPU clock-frequencies to TC2
device-tree' (commit 8f15973ef8c3) taken from Linaro Stable Kernel (LSK)
massaged into mainline.

Cc: Jon Medhurst <tixy@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
index 322fd15..62f89e2 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
@@ -39,6 +39,7 @@
 			reg = <0>;
 			cci-control-port = <&cci_control1>;
 			cpu-idle-states = <&CLUSTER_SLEEP_BIG>;
+			clock-frequency = <1000000000>;
 		};
 
 		cpu1: cpu@1 {
@@ -47,6 +48,7 @@
 			reg = <1>;
 			cci-control-port = <&cci_control1>;
 			cpu-idle-states = <&CLUSTER_SLEEP_BIG>;
+			clock-frequency = <1000000000>;
 		};
 
 		cpu2: cpu@2 {
@@ -55,6 +57,7 @@
 			reg = <0x100>;
 			cci-control-port = <&cci_control2>;
 			cpu-idle-states = <&CLUSTER_SLEEP_LITTLE>;
+			clock-frequency = <800000000>;
 		};
 
 		cpu3: cpu@3 {
@@ -63,6 +66,7 @@
 			reg = <0x101>;
 			cci-control-port = <&cci_control2>;
 			cpu-idle-states = <&CLUSTER_SLEEP_LITTLE>;
+			clock-frequency = <800000000>;
 		};
 
 		cpu4: cpu@4 {
@@ -71,6 +75,7 @@
 			reg = <0x102>;
 			cci-control-port = <&cci_control2>;
 			cpu-idle-states = <&CLUSTER_SLEEP_LITTLE>;
+			clock-frequency = <800000000>;
 		};
 
 		idle-states {
-- 
1.9.1


