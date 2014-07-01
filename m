Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbaGAN15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:27:57 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:42443 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaGAN1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:27:55 -0400
MIME-Version: 1.0
Date: Tue, 1 Jul 2014 18:57:54 +0530
Message-ID: <CAP3RZojgrZKmkhtJDcCcHBxDw+1MECGN5nKd7q7sdofko8Tdug@mail.gmail.com>
Subject: WiFi card through sdio interface in kernel 3.10.17
From: jags gediya <jags.gediya@gmail.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am using linux kernel 3.10.17. I  have interfaced wifi module from
TI to sdio interface.
I am getting following error in kernel logs

mmc0: Switching to 3.3V signaling voltage failed

i have done following configuration in device tree.

reg_3p3v: 3p3v {
            compatible = "regulator-fixed";
            regulator-name = "3P3V";
            regulator-min-microvolt = <3300000>;
            regulator-max-microvolt = <3300000>;
            regulator-always-on;
            };

        wilink_wl_en: tiwi_wlan {
            compatible = "regulator-fixed";
            regulator-name = "wilink_wl_en";
            regulator-min-microvolt = <1800000>;
            regulator-max-microvolt = <1800000>;
            gpio = <&gpio1 12 0>;
            startup-delay-us = <70000>;
            enable-active-high;
        };

and for usdhc1,


&usdhc1 {
    pinctrl-names = "default";
    pinctrl-0 = <&pinctrl_usdhc1_1>;
    bus-width = <4>;
    non-removable;
    vmmc-supply = <&reg_3p3v>;
    vqmmc-supply = <&wilink_wl_en>;
    ocr-limit = <0x80>;
    power-off-card;
    keep-power-in-suspend;
    status = "okay";
};

What can be the reason of error
mmc0: Switching to 3.3V signaling voltage failed?
