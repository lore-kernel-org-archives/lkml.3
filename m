Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaEHPGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:06:41 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:48382 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751885AbaEHPGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:06:39 -0400
Message-ID: <536B9D78.5000602@codethink.co.uk>
Date: Thu, 08 May 2014 16:06:32 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Magnus Damm <damm@opensource.se>, linux-pci@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] pci: rcar host needs OF
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-1-git-send-email-arnd@arndb.de> <1399560990-1402858-14-git-send-email-arnd@arndb.de>
In-Reply-To: <1399560990-1402858-14-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/14 15:56, Arnd Bergmann wrote:
> The pci-rcar driver is enabled for compile tests, and this has
> now shown that the driver cannot build without CONFIG_OF,
> following the inclusion of f8f2fe7355fb "PCI: rcar: Use new OF
> interrupt mapping when possible":
>
> drivers/built-in.o: In function `rcar_pci_map_irq':
> :(.text+0x1cc7c): undefined reference to `of_irq_parse_and_map_pci'
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Magnus Damm <damm@opensource.se>
> Cc: linux-pci@vger.kernel.org
> Cc: linux-sh@vger.kernel.org
> ---
>   drivers/pci/host/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
> index fbbef0b..4675f47 100644
> --- a/drivers/pci/host/Kconfig
> +++ b/drivers/pci/host/Kconfig
> @@ -27,7 +27,7 @@ config PCI_TEGRA
>
>   config PCI_RCAR_GEN2
>   	bool "Renesas R-Car Gen2 Internal PCI controller"
> -	depends on ARCH_SHMOBILE || (ARM && COMPILE_TEST)
> +	depends on ARCH_SHMOBILE || (ARM && OF && COMPILE_TEST)
>   	help
>   	  Say Y here if you want internal PCI support on R-Car Gen2 SoC.
>   	  There are 3 internal PCI controllers available with a single
>

This driver /should/ be able to be built for just the platform case
so it sounds like f8f2fe7355fb stopped this but no-one has yet to
notice.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
