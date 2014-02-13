Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaBMQWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:22:41 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:44709 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaBMQWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:22:39 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATH v2 0/2] spi: Add Qualcomm QUP SPI controller support
Date: Thu, 13 Feb 2014 18:21:12 +0200
Message-Id: <1392308472-30136-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi, 

Following two patches are adding initial support for SPI controller
available in Qualcomm SoC's.

Controller initialization is based on spi_qsd driver available in
CAF repository. 

Controller supports SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP modes, 
up to 4 CS's and from 4 to 32 bits per word. SPI_LOOP mode is limited 
to input FIFO buffer size.

Currently driver support only PIO mode, I am hopping to add also DMA
mode support with dmaengine patches developed by Andy.

Changes since first version:
 - Replace master::transfer_one_message with master::transfer_one and
   master::set_cs.   
 - Use full controller version for compatible string
   "qcom,spi-qup-v2.1.1" and "qcom,spi-qup-v2.2.1". 
 - Ensure that controller internal state is changed only if it is in
   valid state.  
 - Ensure that resources shared between interrupt and thread context
   are properly protected.
 - Use controller auto clock gating for run time power management, 
   instead full clock stop. This should have the same net result, right?
 - Simplify a bit read and write FIFO routines.
 - Several useless print messages removed.
 
Ivan T. Ivanov (2):
  spi: qup: Add device tree bindings information
  spi: Add Qualcomm QUP SPI controller support

 .../devicetree/bindings/spi/qcom,spi-qup.txt       |   85 ++
 drivers/spi/Kconfig                                |   13 +
 drivers/spi/Makefile                               |    1 +
 drivers/spi/spi-qup.c                              |  837 ++++++++++++++++++++
 4 files changed, 936 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
 create mode 100644 drivers/spi/spi-qup.c

-- 
1.7.9.5

