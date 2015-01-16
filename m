Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbbAPKNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:13:19 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:57557 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbbAPKNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:13:13 -0500
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
Subject: Re: [PATCH 00/28] Refine PCI scan interfaces and make generic pci host bridge
Date: Fri, 16 Jan 2015 11:12:43 +0100
Message-ID: <3853153.SqP6BVNhms@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:9Mf8EGrUsk7Uj739obAtoB382C1Ns4WitHbxO53pBmKuyGAN7e9
 F5kJ4CA1Vy2LVZ1wT5HSpNatKFD+HZ9jqAKPgAIx77hTHyE4cSuahq1c590Os9mMcH0aBaS
 4QnBjLh6ANDp0jhgqf5LD/GGeIsKLb+qHp6mO2mdPDiXpG6yDXijxyOfmoEap00W66/Ztpw
 tpvopF3gZ7iGq+1WdRIig==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 09:43:58 Yijing Wang wrote:
> This series is based on Bjorn's pci-next branch.

I think this is a very nice series, hope we can get this into 3.20.

I've replied with a few specific comments, but I see no show-stoppers
and I've already retracted a few comments after seeing the bigger
picture.

> After applied this series, we have following scan interfaces:
> 
> 1. pci_scan_bus_legacy() 
>    parent = NULL, default io/mem/bus resources.
>    for legacy pci scan
> 
> 2. pci_scan_root_bus()
>    for callers provide its own parent and io/mem/bus resources
>    but no platform specific pci_host_bridge operations
> 
> 3. pci_scan_root_bridge()
>    for callers provide its own parent and io/mem/bus resources
>    and pci_host_bridge_ops.

I still think we will need a split interface for drivers to use
that want to call pci_create_host_bridge() manually, but that can
come later as we try to migrate the arm32 host bridge drivers to
a generic interface away from pci_common_init_dev().

Another follow-up would be to move more of the pcibios_*() functions
into pci_host_bridge_ops.

	Arnd
