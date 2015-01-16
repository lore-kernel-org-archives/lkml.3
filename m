Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbbAPJpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:45:00 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:62418 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbbAPJo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:44:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@linux.intel.com>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-alpha@vger.kernel.org,
        linux-m68k@vger.kernel.org, Liviu Dudau <liviu@dudau.co.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 27/28] PCI: Remove platform specific pci_domain_nr()
Date: Fri, 16 Jan 2015 10:44:29 +0100
Message-ID: <1561857.t9qV46uRjC@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1421372666-12288-28-git-send-email-wangyijing@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-28-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Av2Ns9LjAPfBAT7yQFqQLezOcJ+WhrHRcKhwm6fYHNovZJXj+BB
 RAoKP+OHFnau8mAW9GPSqLfkYY/Xcr5lwtPrAIZcj8py6DxMCrlgYzQRwNyFTKRa1iEAzK5
 aYU8D42RZuLSmbtkYSMKhiMF/szEZSQDpQioWKcx3G4kuki5u3a1Xz6ERZy5L3VySeqgmbw
 vYGaN4gXF7ntmjixX9PfA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 09:44:25 Yijing Wang wrote:
> 
> +int pci_domain_nr(struct pci_bus *bus)
> +{
> +       struct pci_host_bridge *host = find_pci_host_bridge(bus);
> +
> +       return host->domain;
> +}
> +EXPORT_SYMBOL_GPL(pci_domain_nr);
> +

Since most of the existing functions are exported as EXPORT_SYMBOL
rather than EXPORT_SYMBOL_GPL, I think the new version should do
the same.

	Arnd
