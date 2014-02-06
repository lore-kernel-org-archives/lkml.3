Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaBFQ7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:59:20 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:41386 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaBFQ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:59:18 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 0/2] spi: Add Qualcomm QUP SPI controller support
Date: Thu,  6 Feb 2014 18:57:46 +0200
Message-Id: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
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
up to 3 CS's and from 4 to 32 bits per word. SPI_LOOP mode is limited 
to input FIFO buffer size.

Currently driver support only PIO mode, I am hopping to add also DMA
mode support with dmaengine patches developed by Andy.

Regards,
Ivan

Ivan T. Ivanov (2):
  spi: qup: Add device tree bindings information
  spi: Add Qualcomm QUP SPI controller support

 .../devicetree/bindings/spi/qcom,spi-qup.txt       |   86 ++
 drivers/spi/Kconfig                                |   14 +
 drivers/spi/Makefile                               |    1 +
 drivers/spi/spi-qup.c                              |  898 ++++++++++++++++++++
 4 files changed, 999 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
 create mode 100644 drivers/spi/spi-qup.c

-- 
1.7.9.5

