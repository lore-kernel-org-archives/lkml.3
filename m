Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbbAVRka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:40:30 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45382 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752349AbbAVRk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:40:26 -0500
Date: Thu, 22 Jan 2015 18:40:00 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@linux.intel.com>,
        <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        <linux-kernel@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Tony Luck <tony.luck@intel.com>,
        <linux-ia64@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>, <linux-alpha@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, Liviu Dudau <liviu@dudau.co.uk>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory =?UTF-8?B?Q2zDqW1lbnQ=?= 
	<gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Nadav Haklai <nadavh@marvell.com>
Subject: Re: [PATCH v2 23/30] PCI/mvebu: Use pci_common_init_dev() to
 simplify code
Message-ID: <20150122184000.63ba06bb@free-electrons.com>
In-Reply-To: <1421800225-26230-24-git-send-email-wangyijing@huawei.com>
References: <1421800225-26230-1-git-send-email-wangyijing@huawei.com>
	<1421800225-26230-24-git-send-email-wangyijing@huawei.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Yijing Wang,

On Wed, 21 Jan 2015 08:30:18 +0800, Yijing Wang wrote:
> Mvebu_pcie_scan_bus() is not necessary, we could use
> pci_common_init_dev() instead of pci_common_init(),
> and pass the device pointer as the parent. Then
> pci_scan_root_bus() will be called to scan the pci busses.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> CC: Jason Cooper <jason@lakedaemon.net>

While I'm fine with the change to pci_common_init_dev(), I am not so
sure about the removal of mvebu_pcie_scan_bus(). I vaguely remember
that we intentionally did not use the default function for a specific
reason. Of course, this was a long time ago, and I don't remember the
reason. I would have to take a bit of time to 1/ review the archives of
the discussion surrounding the pcie-mvebu driver, and 2/ test your
patch to validate it works fine on HW.

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
