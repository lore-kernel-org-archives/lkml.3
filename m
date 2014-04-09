Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbaDIRop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:44:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46855 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaDIRon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:44:43 -0400
Message-ID: <53458708.40702@codeaurora.org>
Date: Wed, 09 Apr 2014 10:44:40 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Christopher Covington <cov@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] ARM: msm: Make MSM_HAS_DEBUG_UART_HS option visible
 to multiplatform targets
References: <53455268.4030003@codeaurora.org> <1397053585-26201-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1397053585-26201-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/14 07:26, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
> High Speed UART is available also in new multiplatform QCOM targets.
>
> This fixes:
>
> scripts/kconfig/conf --silentoldconfig Kconfig
> warning: (DEBUG_MSM8660_UART && DEBUG_MSM8960_UART && DEBUG_MSM8974_UART) selects MSM_HAS_DEBUG_UART_HS which has unmet direct dependencies (ARCH_MSM)
> warning: (DEBUG_MSM8660_UART && DEBUG_MSM8960_UART && DEBUG_MSM8974_UART) selects MSM_HAS_DEBUG_UART_HS which has unmet direct dependencies (ARCH_MSM)
>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

It might be better to move the config out of mach-msm into
arch/arm/Kconfig.debug. I think the eventual goal is to remove all these
#defines for the physical/virtual address and have users enter the
addresses in Kconfig similar to how Russell has done for the pl01X. If
that happens then we end up with a DEBUG_MSM_UART (for 7201,8x50, 7x30)
and DEBUG_QCOM_UARTDM for all others and the help text would indicate
which addresses to use.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

