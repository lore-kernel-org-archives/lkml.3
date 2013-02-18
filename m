Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab3BRAEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 19:04:06 -0500
Received: from gloria.sntech.de ([95.129.55.99]:44634 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab3BRAEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 19:04:05 -0500
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: [PATCH v2 0/3] ARM: S3C24XX: Add devicetree support for s3c2416
Date: Mon, 18 Feb 2013 01:03:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302180103.53084.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second installment of beginning devicetree support the
Samsung S3C24xx architectures and focuses on the s3c2416 for now.

Included is the devicetree support for the s3c24xx irq controller and
basic support for smdk2416 boards, which can sucessfully boot.


After the discussion with Thomas Abraham on v1 and staring to long at all of
this, I'm not even sure if having the interrupt mapping in the binding
is the correct way to go anymore.

The key positive aspect of this solution is, that after everything is running
via dt all the SoC specific mapping tables in the driver can go away, cutting
its length in half.

The other option would be as Thomas suggested to define specific irq-controller
types (i.e. s3c2416-intc, s3c2443-intc, ... resulting in 16 types) and keep
the mapping data in the code, as it is now.

So I would be very thankful for a bit of guidance on what is the better way.


The series depends on the finalized s3c24xx irq rework, which probably won't
make it into 3.9 and also the clocksource dt support by Tomasz Figa, which
are not in any tree yet.


Changes since v1:
- adapt to changes in the underlying s3c24xx irq rework
  = more shared init code
- use irqchip infrastructure
- limit number of possible irq-types to not encode implementation details
  into the binding
- include new samsung-clocksource

Heiko Stuebner (3):
  ARM: S3C24XX: move irq driver to drivers/irqchip
  irqchip: irq-s3c24xx: add devicetree support
  ARM: S3C24XX: Add devicetree support and dt-board file for s3c2416 SoCs

 .../interrupt-controller/samsung,s3c24xx-irq.txt   |   53 ++++++
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/s3c2416-smdk2416.dts             |   79 ++++++++
 arch/arm/boot/dts/s3c2416.dtsi                     |  193 ++++++++++++++++++++
 arch/arm/boot/dts/s3c24xx.dtsi                     |  165 +++++++++++++++++
 arch/arm/mach-s3c24xx/Kconfig                      |   10 +
 arch/arm/mach-s3c24xx/Makefile                     |    3 +-
 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c            |   91 +++++++++
 drivers/irqchip/Makefile                           |    1 +
 .../irq.c => drivers/irqchip/irq-s3c24xx.c         |  128 +++++++++++++
 10 files changed, 723 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/samsung,s3c24xx-irq.txt
 create mode 100644 arch/arm/boot/dts/s3c2416-smdk2416.dts
 create mode 100644 arch/arm/boot/dts/s3c2416.dtsi
 create mode 100644 arch/arm/boot/dts/s3c24xx.dtsi
 create mode 100644 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c
 rename arch/arm/mach-s3c24xx/irq.c => drivers/irqchip/irq-s3c24xx.c (92%)

-- 
1.7.2.3

