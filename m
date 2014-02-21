Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaBULKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:10:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35743 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755135AbaBULKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:10:32 -0500
Date: Fri, 21 Feb 2014 11:09:50 +0000
From: Will Deacon <will.deacon@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm-perf
 tree
Message-ID: <20140221110950.GB8731@mudshark.cambridge.arm.com>
References: <20140221115857.3ea3d7277d03c5b6b4d26488@canb.auug.org.au>
 <CAOesGMimJxYLor11EQ-Cn9BnZGg60VrOFC8ZqBdC+wNunptm8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMimJxYLor11EQ-Cn9BnZGg60VrOFC8ZqBdC+wNunptm8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 01:02:47AM +0000, Olof Johansson wrote:
> On Thu, Feb 20, 2014 at 4:58 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/boot/dts/qcom-msm8960-cdp.dts between commit a1d711938959 ("ARM:
> > dts: msm: Add krait-pmu to platforms with Krait CPUs") from the arm-perf
> > tree and commit cc60a1a4d47a ("ARM: dts: msm: split out msm8660 and
> > msm8960 soc into dts include") from the arm-soc tree.
> >
> > I fixed it up (probably not the best way ... see below) and can carry the
> > fix as necessary (no action is required).
> 
> Will, I think we'll be better off taking dts changes through arm-soc,
> unless there's a good reason to take them through other trees (such as
> the perf tree in this case). Is there, or should we move them over?

Sure, I can drop that from my tree (it came as part of the series adding
Krait PMU support).

I've included the original patch below so you can put it into arm-soc.

Cheers,

Will

--->8

commit a1d711938959935436e935ebb4ea6199bceb021d
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Fri Feb 7 21:01:25 2014 +0000

    ARM: dts: msm: Add krait-pmu to platforms with Krait CPUs
    
    Allows us to probe the performance counters on Krait CPUs.
    
    Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
    Signed-off-by: Will Deacon <will.deacon@arm.com>

diff --git a/arch/arm/boot/dts/qcom-msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
index 7c30de4fa302..66c59a6a722c 100644
--- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
@@ -9,6 +9,12 @@
 	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
 	interrupt-parent = <&intc>;
 
+	cpu-pmu {
+		compatible = "qcom,krait-pmu";
+		interrupts = <1 10 0x304>;
+		qcom,no-pc-write;
+	};
+
 	intc: interrupt-controller@2000000 {
 		compatible = "qcom,msm-qgic2";
 		interrupt-controller;
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 9e5dadb101eb..1eff4130cde0 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -9,6 +9,11 @@
 	compatible = "qcom,msm8974";
 	interrupt-parent = <&intc>;
 
+	cpu-pmu {
+		compatible = "qcom,krait-pmu";
+		interrupts = <1 7 0xf04>;
+	};
+
 	soc: soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
