Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbaBUPgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:36:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49039 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaBUPgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:36:03 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH v3 2/2] i2c: New bus driver for the Qualcomm QUP I2C controller
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1392943090-30556-3-git-send-email-bjorn.andersson@sonymobile.com>
Date: Fri, 21 Feb 2014 09:35:57 -0600
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Andy Gross <agross@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <92B0AE30-5CDF-43FC-8588-EEF0C5F86266@codeaurora.org>
References: <1392943090-30556-1-git-send-email-bjorn.andersson@sonymobile.com> <1392943090-30556-3-git-send-email-bjorn.andersson@sonymobile.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 20, 2014, at 6:38 PM, Bjorn Andersson <bjorn.andersson@sonymobile.com> wrote:

> This bus driver supports the QUP i2c hardware controller in the Qualcomm SOCs.
> The Qualcomm Universal Peripheral Engine (QUP) is a general purpose data path
> engine with input/output FIFOs and an embedded i2c mini-core. The driver
> supports FIFO mode (for low bandwidth applications) and block mode (interrupt
> generated for each block-size data transfer).
> 
> Cc: Andy Gross <agross@codeaurora.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
> drivers/i2c/busses/Kconfig   |   10 +
> drivers/i2c/busses/Makefile  |    1 +
> drivers/i2c/busses/i2c-qup.c |  772 ++++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 783 insertions(+)
> create mode 100644 drivers/i2c/busses/i2c-qup.c
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index f5ed031..403e196 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -648,6 +648,16 @@ config I2C_PXA_SLAVE
> 	  is necessary for systems where the PXA may be a target on the
> 	  I2C bus.
> 
> +config I2C_QUP
> +	tristate "Qualcomm QUP based I2C controller"
> +	depends on ARCH_MSM

ARCH_QCOM

> +	help
> +	  If you say yes to this option, support will be included for the
> +	  built-in I2C interface on the Qualcomm SoCs.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called i2c-qup.
> +
> config I2C_RIIC
> 	tristate "Renesas RIIC adapter"
> 	depends on ARCH_SHMOBILE || COMPILE_TEST

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

