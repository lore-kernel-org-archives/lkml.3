Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbbAQQjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 11:39:53 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47633 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbbAQQju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 11:39:50 -0500
Message-ID: <54BA9052.9080904@cogentembedded.com>
Date: Sat, 17 Jan 2015 19:39:46 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>
CC: Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-alpha@vger.kernel.org,
        linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 23/28] PCI/designware: Use pci_scan_root_bus() for simplicity
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-24-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1421372666-12288-24-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/16/2015 4:44 AM, Yijing Wang wrote:

> Use pci_scan_root_bus() instead of pci_create_root_bus() +
> pci_scan_child_bus() for simplicity.

> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>   drivers/pci/host/pcie-designware.c |    4 +---
>   1 files changed, 1 insertions(+), 3 deletions(-)

> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index eef3111..d37fe27 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -725,13 +725,11 @@ static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
>   	struct pcie_port *pp = sys_to_pcie(sys);
>
>   	pp->root_bus_nr = sys->busnr;
> -	bus = pci_create_root_bus(pp->dev, sys->busnr,
> +	bus = pci_scan_root_bus(pp->dev, sys->busnr,
>   				  &dw_pcie_ops, sys, &sys->resources);

    Please realign this line, so that it still starts under 'pp'.

WBR, Sergei

