Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbaAFUHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:07:32 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37082 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbaAFUHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:07:30 -0500
Message-ID: <52CB0CFE.4070901@wwwdotorg.org>
Date: Mon, 06 Jan 2014 13:07:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Wolfram Sang <wsa@the-dreams.de>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: Re: [PATCH v2 1/6] ARM: tegra: export apb dma readl/writel
References: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com> <1387891931-9854-2-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1387891931-9854-2-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2013 06:32 AM, Peter De Schrijver wrote:
> Export APB DMA readl and writel. These are needed because we can't access
> the fuses directly on Tegra20 without potentially causing a system hang.

This does a lot more than just export the functions; it also changes the
prototypes. I'm not sure why the prototype change was required/useful.
This needs to be mentioned in the commit description/subject, and the
reasoning explained too.

> diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h

> +#if defined(CONFIG_TEGRA20_APB_DMA)
> +void tegra_apb_io_init(void);

This seems to be an internal function; why is this one publicly
prototyped and/or stubbed?

