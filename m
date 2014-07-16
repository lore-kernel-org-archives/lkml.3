Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbaGPMTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:19:48 -0400
Received: from smtp-out-134.synserver.de ([212.40.185.134]:1086 "EHLO
	smtp-out-130.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932287AbaGPMTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:19:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 2956
Message-ID: <53C66DE3.5080502@metafoo.de>
Date: Wed, 16 Jul 2014 14:19:47 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: pramod.gurav.etc@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
CC: Josh Cartwright <joshc@codeaurora.org>, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regmap: Kconfig: Select SPMI when REGMAP_SPMI is selected
References: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>
In-Reply-To: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 01:39 PM, pramod.gurav.etc@gmail.com wrote:
> From: Pramod Gurav <pramod.gurav.etc@gmail.com>
>
> REGMAP_SPMI module calls some functions from SPMI hence build breaks
> when SPMI is not enabled while compiling REGMAP_SPMI with below linker
> errors:
>
> drivers/built-in.o: In function `regmap_spmi_ext_read':
> :(.text+0x1143ec): undefined reference to `spmi_ext_register_read'
> :(.text+0x11443c): undefined reference to `spmi_ext_register_readl'
> drivers/built-in.o: In function `regmap_spmi_ext_gather_write':
> :(.text+0x1144c4): undefined reference to `spmi_ext_register_write'
> :(.text+0x114520): undefined reference to `spmi_ext_register_writel'
> drivers/built-in.o: In function `regmap_spmi_base_read':
> :(.text+0x1145b8): undefined reference to `spmi_register_read'
> drivers/built-in.o: In function `regmap_spmi_base_gather_write':
> :(.text+0x114630): undefined reference to `spmi_register_write'
> :(.text+0x11465c): undefined reference to `spmi_register_zero_write'
>
> Signed-off-by: Pramod Gurav <pramod.gurav.etc@gmail.com>
> CC: Josh Cartwright <joshc@codeaurora.org>
> CC: Mark Brown <broonie@linaro.org>
> ---
> This was found when I enabled support for Qualcomm QPNP PMICs and was
> compiling it. It selects REGMAP_SPMI and hence the crash.


Any driver that does select REGMAP_SPMI needs to depends on SPMI. So the 
correct fix for this issue is to make sure that the driver can only be 
enabled if SPMI is enabled.

- Lars
