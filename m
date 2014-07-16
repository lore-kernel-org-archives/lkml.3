Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbaGPCiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:38:51 -0400
Received: from 203-174-129-26.bri.static-ipl.aapt.com.au ([203.174.129.26]:46872
	"EHLO bne.vrt.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbaGPCio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:38:44 -0400
From: Stuart Longland <stuartl@vrt.com.au>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Add device tree support to ISL12022 driver
Date: Wed, 16 Jul 2014 12:28:24 +1000
Message-Id: <1405477705-16885-1-git-send-email-stuartl@vrt.com.au>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The attached patch adds support for configuring the ISL12022 real-time clock
via the Device tree framework.  This is based on what I've seen in the related
ISL12057 driver, it has been tested and works on a Technologic Systems TS-7670
device which uses a ISL12020 RTC device, my device tree looks like this:

	apbx@80040000 {
		i2c0: i2c@80058000 {
			pinctrl-names = "default";
			pinctrl-0 = <&i2c0_pins_a>;
			clock-frequency = <400000>;
			status = "okay";

			isl12022@0x6f {
				compatible = "isl,isl12022";
				reg = <0x6f>;
			};
		};
		... etc
	};

Regards,
Stuart Longland

