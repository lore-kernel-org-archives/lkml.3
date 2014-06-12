Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaFLTeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:34:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45695 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaFLTem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:34:42 -0400
From: Andy Gross <agross@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Daniel Sneddon <dsneddon@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [Patch v2 0/3] spi: qup: Fixes and new version support
Date: Thu, 12 Jun 2014 14:34:09 -0500
Message-Id: <1402601652-24641-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches provides a few fixes for the SPI QUP driver and support for
an earlier version of the QUP.

The first patch removes the use of the controller's own chip select
functionality.  The user should instead use GPIOs and make use of the SPI core's
GPIO chip select feature.

The second patch addresses failures during probing of slave devices that
required SPI transactions.  The spi_register_master needs to be called after
the runtime pm is initialized.

The last patch adds support for V1.1.1 of the QUP.  This version of the
controller is present in earlier devices (APQ8064, IPQ8064, and MSM8960).

Andy Gross (3):
  spi: qup: Remove chip select function
  spi: qup: Fix order of spi_register_master
  spi: qup: Add support for v1.1.1

 .../devicetree/bindings/spi/qcom,spi-qup.txt       |   12 ++-
 drivers/spi/spi-qup.c                              |   80 +++++++++-----------
 2 files changed, 46 insertions(+), 46 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

