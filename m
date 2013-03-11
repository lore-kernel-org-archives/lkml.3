Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3CKRiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:38:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43057 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3CKRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:38:10 -0400
Message-ID: <513E167E.8030000@wwwdotorg.org>
Date: Mon, 11 Mar 2013 11:38:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, pdeschrijver@nvidia.com
Subject: Re: [PATCH V2 3/5] ARM: DT: tegra114:add aliases and DMA requestor
 for serial controller
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com> <1362852678-13421-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1362852678-13421-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2013 11:11 AM, Laxman Dewangan wrote:
> Add APB DMA requestor and serial aliases for serial controller.
> There will be two serial driver i.e. 8250 based simple serial driver
> and APB DMA based serial driver for higher baudrate and performace.
> 
> The simple serial driver get enabled with compatible "nvidia,tegra114-uart",
> "nvidia,tegra20-uart" and APB DMA based driver will get enabled with
> compatible "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart".
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Remove UARTB car id correction. Make the compatible with tegra114 and
>   tegra30 for hsuart and tegra20 for simple uart driver.

Why the difference for the two drivers? Either the HW is compatible with
all 3 of 114/30/20 (in which case you only need list 114/20 in the
compatible value), or it's not compatible with either 30/20, since we
already know that 30/20 are compatible with each-other (in which case
you should only list 114 in the compatible property).
