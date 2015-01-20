Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbbATQC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:02:56 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:44963 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbATQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:02:10 -0500
From: Stefan Agner <stefan@agner.ch>
To: jic23@kernel.org
Cc: shawn.guo@linaro.org, B38611@freescale.com, maitysanchayan@gmail.com,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 0/3] iio: adc: vf610: respect ADC clocking limitations
Date: Tue, 20 Jan 2015 17:02:00 +0100
Message-Id: <1421769723-28677-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Respect ADC clocking limitations which lead to bogous reading on
500MHz clocked Vybrid SoC's. Additionally, also implement a
sysfs-property to configure the conversion mode available in this
ADC peripherial.

Stefan Agner (3):
  iio: adc: vf610: use ADC clock within specification
  iio: adc: vf610: implement configurable conversion modes
  ARM: dts: add property for maximum ADC clock frequencies

 .../devicetree/bindings/iio/adc/vf610-adc.txt      |   9 ++
 arch/arm/boot/dts/vfxxx.dtsi                       |   4 +
 drivers/iio/adc/vf610_adc.c                        | 175 +++++++++++++++++----
 3 files changed, 156 insertions(+), 32 deletions(-)

-- 
2.2.2

