Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbbA1UyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:54:25 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:39636 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbbA1UyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:19 -0500
Message-ID: <54C8A66E.3070306@mm-sol.com>
Date: Wed, 28 Jan 2015 11:05:50 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-soc@vger.kernel.org
Subject: Re: [PATCH 1/6] soc: qcom: gsbi: Add support for ADM CRCI muxing
References: <1422396644-21714-1-git-send-email-agross@codeaurora.org> <1422396644-21714-2-git-send-email-agross@codeaurora.org>
In-Reply-To: <1422396644-21714-2-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 01/28/2015 12:10 AM, Andy Gross wrote:
> This patch adds automatic configuration for the ADM CRCI muxing required to
> support DMA operations for GSBI clients.  The GSBI mode and instance determine
> the correct TCSR ADM CRCI MUX value that must be programmed so that the DMA
> works properly.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
>  .../devicetree/bindings/soc/qcom/qcom,gsbi.txt     |   17 ++-
>  drivers/soc/qcom/Kconfig                           |    1 +
>  drivers/soc/qcom/qcom_gsbi.c                       |  148 +++++++++++++++++++-
>  3 files changed, 158 insertions(+), 8 deletions(-)
> 

<snip>

> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> index 7bd2c94..32f20be 100644
> --- a/drivers/soc/qcom/Kconfig
> +++ b/drivers/soc/qcom/Kconfig
> @@ -4,6 +4,7 @@
>  config QCOM_GSBI
>          tristate "QCOM General Serial Bus Interface"
>          depends on ARCH_QCOM
> +	select MFD_SYSCON

Wrong indentation? In fact the original Kconfig entry has spaces instead
of tabs, could you prepare a cleanup patch for this.

>          help
>            Say y here to enable GSBI support.  The GSBI provides control
>            functions for connecting the underlying serial UART, SPI, and I2C

<snip>

-- 
regards,
Stan
