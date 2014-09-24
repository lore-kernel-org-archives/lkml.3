Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaIXM5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:57:21 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:49680 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaIXM5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:57:19 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Fugang Duan <B38611@freescale.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Jean Delvare <jdelvare@suse.de>, Philippe Reynes <tremyfr@yahoo.fr>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH v3 0/2] Intial support for voltage ADC
Date: Wed, 24 Sep 2014 15:56:53 +0300
Message-Id: <1411563415-11933-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:

 - fixes per comments from Hartmut Knaack and Jonathan Cameron.
 - now register through IIO core only ADC channels described in DT.
 - register TEMP_DIE channel as IIO_TEMP type and as processed return value.
 - implement INFO_RAW and INFO_SCALE masks support in order to avoid losing 
   ADC precision.
 - various cleanups.

-------------------------------------------------------------------------------
Changes since v1:

 - the review comments from Peter Meerwald and Hartmut Knaack are taken into
   account
 - the driver private sysfs attributes are dropped out.
 - dt binding document is changed in the section of adc channel nodes - now the
   adc channel number is represented by "reg" property.
 - various cleanups found during preparation of version 2.

-------------------------------------------------------------------------------
Introduce inital support for VADC inside Qualcomm SPMI PMICs.
The vadc driver is reworked version of the same downstream
driver but now it is implemented through Industrial IO core.

Stanimir Varbanov (2):
  iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
  DT: iio: vadc: document dt binding

 .../devicetree/bindings/iio/adc/qcom,spmi-vadc.txt |  130 +++
 drivers/iio/adc/Kconfig                            |   10 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/qcom-spmi-vadc.c                   | 1029 ++++++++++++++++++++
 include/dt-bindings/iio/qcom,spmi-pmic-vadc.h      |  119 +++
 5 files changed, 1289 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
 create mode 100644 drivers/iio/adc/qcom-spmi-vadc.c
 create mode 100644 include/dt-bindings/iio/qcom,spmi-pmic-vadc.h

