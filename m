Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbbAPJmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:42:08 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:62978 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbbAPJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:42:04 -0500
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
        Jiang Liu <jiang.liu@linux.intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 08/28] PCI: Introduce pci_host_assign_domain_nr() to assign domain
Date: Fri, 16 Jan 2015 10:40:26 +0100
Message-ID: <3026954.09KG7UaUTi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <13182982.DnZJMY2KHL@wuerfel>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-9-git-send-email-wangyijing@huawei.com> <13182982.DnZJMY2KHL@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:v+2DdU5jvvHa/zckgtsCpbKmwG4Z3iU/JnURckB6+/z53/cPVOP
 s9/gnR00ndIANAAlHy5W70cHECXVCC5dPByz+r3WgULpxifxUQt2iqxn6LOB+saW4uavy1j
 XzdaOgM7cjNC040mmDgmeE/waa0aFG1txlZLLDhrYL1bJUrKuvmS6MW32sXzFewjnmmOawW
 v74GfDZE5IqnuuBa8C9jw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 10:08:45 Arnd Bergmann wrote:
> On Friday 16 January 2015 09:44:06 Yijing Wang wrote:
> > Introduce pci_host_assign_domain_nr() to assign domain
> > number for pci_host_bridge. Later we will remove
> > pci_bus_assign_domain_nr().
> > 
> > Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> 
> I'm confused: the same code is already part of the PCI tree, but with
> Lorenzo Pieralisi listed as the patch author. The code is good,
> and I acked it in the past, but one of you is (probably by accident)
> misattributing the patch.
> 
> Assuming that the patch that is already merged in next is the right
> one, I think you should rebase your series on top of
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git#next
> 
> to avoid conflicts like this one.
>

I think I just got confused because the code duplicates most of
pci_bus_assign_domain_nr(). Maybe this can be done in a better way
by splitting the existing function into 

static int pci_assign_domain_nr(struct device *)
{
	... /* most of pci_bus_assign_domain_nr */

	return domain;
}

void pci_host_assign_domain_nr(struct pci_host_bridge *host)
{
	host->domain = pci_assign_domain_nr(host->dev.parent);
}

void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
{
	bus->domain_nr = pci_assign_domain_nr(parent);
}
