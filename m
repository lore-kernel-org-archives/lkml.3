Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbbAPJf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:35:56 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:62211 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbbAPJfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:35:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-alpha@vger.kernel.org,
        linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH 09/28] PCI: Separate pci_host_bridge creation out of pci_create_root_bus()
Date: Fri, 16 Jan 2015 10:34:34 +0100
Message-ID: <11966423.5s0rO0b8cE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1421372666-12288-10-git-send-email-wangyijing@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-10-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:V4OsQW4fvRS1DXpV6Camn07cj1qXBzyHnT9RRoMZy1X+AXV3H5R
 eVR+tWwr8fRXOmoWS+WgoNSCoHkwxsSHhOZ3yW5exI9IlVzSiNcETnzGsnXOP077fNDJ8Um
 1t7gtCklvc8NtCU/8YNxlTwB/tHo730EclPgo0mkohrY9ba6cq+Uu7J5S4Y6V/KvhEB+uBP
 rZK48B4yC8fKtzb2HqgCQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 09:44:07 Yijing Wang wrote:
> We want to make a generic pci_host_bridge, then we could
> place common PCI infos like domain number in it. Ripping
> out pci_host_bridge creation from pci_create_root_bus()
> make code more better readability. Further more, we could
> use the generic pci_host_bridge to hold host bridge specific
> operations like pcibios_root_bridge_prepare().
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> 

I assume this patch is doing the right thing, but the description
above doesn't really tell me enough to be sure.

This is supposed to be transparent to the callers, right? If
so, please mention it explicitly in the text.

Also you don't explain what the list of host bridges is
used for. Maybe you can split this out into a separate patch
so you have one patch that just moves code from one file
to the other but no functional changes, and a second patch
that exports pci_create_host_bridge and introduces the list,
with an explanation of what it is used for.

	Arnd
