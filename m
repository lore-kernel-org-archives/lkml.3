Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3H3VMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 17:12:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48464 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab3H3VMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:12:50 -0400
Message-ID: <52210AB9.2090104@infradead.org>
Date: Fri, 30 Aug 2013 14:12:25 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list@broadcom.com, linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 30 (brcmfmac)
References: <20130829200013.d9dde1eb64686a32c661b5d3@canb.auug.org.au>
In-Reply-To: <20130829200013.d9dde1eb64686a32c661b5d3@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/13 03:00, Stephen Rothwell wrote:
> Hi all,
> 

on x86_64:

when
CONFIG_MMC=m
CONFIG_BRCMUTIL=y
CONFIG_BRCMFMAC=y
CONFIG_BRCMFMAC_SDIO=y


This bool kconfig symbol:

config BRCMFMAC_SDIO
	bool "SDIO bus interface support for FullMAC driver"
	depends on MMC

allows BRCMFMAC_SDIO to be y even when MMC=m.

Is there a reasonable solution to this?


This causes many build errors:

drivers/built-in.o: In function `brcmf_sdio_assert_info':
dhd_sdio.c:(.text+0x39609b): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x3960d9): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_readframes':
dhd_sdio.c:(.text+0x396a62): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x396a9b): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x396ae6): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x396b1b): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x396bd9): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x396c03): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x396f76): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x396fcc): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x397115): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x3972d0): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x397632): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x397699): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x39770b): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x397731): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x397796): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x3977b6): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x3977ff): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x3978b6): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x397940): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x397963): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x3979c1): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x397a90): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x397ab7): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_txpkt.constprop.16':
dhd_sdio.c:(.text+0x3981d7): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x398213): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x3985d6): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_release':
dhd_sdio.c:(.text+0x398a5e): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x398a85): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_probe':
(.text+0x398d04): undefined reference to `sdio_claim_host'
drivers/built-in.o: In function `brcmf_sdbrcm_probe':
(.text+0x398d3c): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_probe':
(.text+0x398e91): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_probe':
(.text+0x399087): undefined reference to `sdio_claim_host'
drivers/built-in.o: In function `brcmf_sdbrcm_probe':
(.text+0x3990d0): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_readshared':
dhd_sdio.c:(.text+0x39953c): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x39956e): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_bus_txctl':
dhd_sdio.c:(.text+0x399c14): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x399c2d): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x399cac): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x399cf0): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x399ec8): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x399efe): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x399ff4): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_bus_stop':
dhd_sdio.c:(.text+0x39a0cb): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x39a179): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_dataworker':
dhd_sdio.c:(.text+0x39a281): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x39a2f1): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x39a852): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x39a86d): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x39aa08): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x39aa4a): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x39aaa1): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x39aac1): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_bus_init':
dhd_sdio.c:(.text+0x39acdb): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x39ad05): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x39ad29): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x39b086): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x39b2c7): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_watchdog_thread':
dhd_sdio.c:(.text+0x39b6dc): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x39b6f7): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x39b735): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x39b75b): undefined reference to `sdio_release_host'
dhd_sdio.c:(.text+0x39b790): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x39b7ae): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_buffrw':
bcmsdh.c:(.text+0x39bf67): undefined reference to `mmc_set_data_timeout'
bcmsdh.c:(.text+0x39bf76): undefined reference to `mmc_wait_for_req'
bcmsdh.c:(.text+0x39c180): undefined reference to `sdio_readsb'
bcmsdh.c:(.text+0x39c19d): undefined reference to `sdio_memcpy_fromio'
bcmsdh.c:(.text+0x39c211): undefined reference to `sdio_memcpy_toio'
drivers/built-in.o: In function `brcmf_sdio_intr_unregister':
(.text+0x39c6fd): undefined reference to `sdio_claim_host'
drivers/built-in.o: In function `brcmf_sdio_intr_unregister':
(.text+0x39c706): undefined reference to `sdio_release_irq'
drivers/built-in.o: In function `brcmf_sdio_intr_unregister':
(.text+0x39c70f): undefined reference to `sdio_release_irq'
drivers/built-in.o: In function `brcmf_sdio_intr_unregister':
(.text+0x39c718): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_intr_unregister':
(.text+0x39c72d): undefined reference to `sdio_claim_host'
drivers/built-in.o: In function `brcmf_sdio_intr_unregister':
(.text+0x39c758): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_intr_register':
(.text+0x39c809): undefined reference to `sdio_claim_host'
drivers/built-in.o: In function `brcmf_sdio_intr_register':
(.text+0x39c819): undefined reference to `sdio_claim_irq'
drivers/built-in.o: In function `brcmf_sdio_intr_register':
(.text+0x39c829): undefined reference to `sdio_claim_irq'
drivers/built-in.o: In function `brcmf_sdio_intr_register':
(.text+0x39c832): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_intr_register':
(.text+0x39c906): undefined reference to `sdio_claim_host'
drivers/built-in.o: In function `brcmf_sdio_intr_register':
(.text+0x39c962): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_ramrw':
(.text+0x39ce75): undefined reference to `sdio_claim_host'
drivers/built-in.o: In function `brcmf_sdio_ramrw':
(.text+0x39cfc1): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_pd_probe':
bcmsdh_sdmmc.c:(.text+0x39d177): undefined reference to `sdio_register_driver'
drivers/built-in.o: In function `brcmf_sdio_suspend':
bcmsdh_sdmmc.c:(.text+0x39d1f5): undefined reference to `sdio_get_host_pm_caps'
bcmsdh_sdmmc.c:(.text+0x39d207): undefined reference to `sdio_set_host_pm_flags'
drivers/built-in.o: In function `brcmf_sdio_pd_remove':
bcmsdh_sdmmc.c:(.text+0x39d268): undefined reference to `sdio_unregister_driver'
drivers/built-in.o: In function `brcmf_sdioh_request_byte':
(.text+0x39d78e): undefined reference to `sdio_f0_readb'
drivers/built-in.o: In function `brcmf_sdioh_request_byte':
(.text+0x39d7c4): undefined reference to `sdio_writeb'
drivers/built-in.o: In function `brcmf_sdioh_request_byte':
(.text+0x39d7fd): undefined reference to `sdio_f0_writeb'
drivers/built-in.o: In function `brcmf_sdioh_request_byte':
(.text+0x39d81c): undefined reference to `sdio_readb'
drivers/built-in.o: In function `brcmf_sdioh_request_byte':
(.text+0x39d844): undefined reference to `sdio_enable_func'
drivers/built-in.o: In function `brcmf_sdioh_request_byte':
(.text+0x39d889): undefined reference to `sdio_writeb'
drivers/built-in.o: In function `brcmf_sdioh_request_byte':
(.text+0x39d8a1): undefined reference to `sdio_disable_func'
drivers/built-in.o: In function `brcmf_sdioh_request_word':
(.text+0x39d96c): undefined reference to `sdio_readw'
drivers/built-in.o: In function `brcmf_sdioh_request_word':
(.text+0x39d9b7): undefined reference to `sdio_writew'
drivers/built-in.o: In function `brcmf_sdioh_request_word':
(.text+0x39d9cc): undefined reference to `sdio_readl'
drivers/built-in.o: In function `brcmf_sdioh_request_word':
(.text+0x39d9f2): undefined reference to `sdio_writel'
drivers/built-in.o: In function `brcmf_sdioh_attach':
(.text+0x39da5a): undefined reference to `sdio_claim_host'
drivers/built-in.o: In function `brcmf_sdioh_attach':
(.text+0x39da69): undefined reference to `sdio_set_block_size'
drivers/built-in.o: In function `brcmf_sdioh_attach':
(.text+0x39da83): undefined reference to `sdio_set_block_size'
drivers/built-in.o: In function `brcmf_sdioh_attach':
(.text+0x39db3e): undefined reference to `sdio_enable_func'
drivers/built-in.o: In function `brcmf_sdioh_attach':
(.text+0x39db48): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdioh_detach':
(.text+0x39dbab): undefined reference to `sdio_claim_host'
drivers/built-in.o: In function `brcmf_sdioh_detach':
(.text+0x39dbb4): undefined reference to `sdio_disable_func'
drivers/built-in.o: In function `brcmf_sdioh_detach':
(.text+0x39dbbd): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdioh_detach':
(.text+0x39dbc6): undefined reference to `sdio_claim_host'
drivers/built-in.o: In function `brcmf_sdioh_detach':
(.text+0x39dbcf): undefined reference to `sdio_disable_func'
drivers/built-in.o: In function `brcmf_sdioh_detach':
(.text+0x39dbd8): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_exit':
(.text+0x39dc38): undefined reference to `sdio_unregister_driver'
drivers/built-in.o: In function `brcmf_sdio_init':
(.text+0x39dca2): undefined reference to `sdio_register_driver'


-- 
~Randy
