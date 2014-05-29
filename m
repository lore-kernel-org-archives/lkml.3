Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaE2TBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:01:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39751 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaE2TBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:01:30 -0400
Message-ID: <53878407.3050409@wwwdotorg.org>
Date: Thu, 29 May 2014 13:01:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/5] efuse driver for Tegra
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 06:54 AM, Peter De Schrijver wrote:
> This driver allows userspace to read the raw efuse data. Its userspace
> interface is modelled after the sunxi_sid driver which provides similar
> functionality for some Allwinner SoCs. It has been tested on
> Tegra20 (ventana), Tegra30 (beaverboard), Tegra114 (dalmore) and
> Tegra124 (jetson TK1).

> Changes since v4:
> 
> * Provide fallback to hardcoded 0x70000800 in case the apbmisc DT node is
>   missing. This is exactly what the current code does and prevents a system
>   crash in that case due to an invalid memory access by tegra_read_chipid()

Wouldn't it be better to simply return an error?
