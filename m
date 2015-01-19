Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbbASJvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:51:09 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:56893 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbASJvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:51:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Yijing Wang <wangyijing@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
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
Date: Mon, 19 Jan 2015 10:50:30 +0100
Message-ID: <2124926.gSbG0l1jIy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54BC6894.6060500@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <3026954.09KG7UaUTi@wuerfel> <54BC6894.6060500@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:joVrAckJ4T53AE9vCH1GKo2q9qrXEKODMsHTOY533Ymcrp6AcPa
 SESkW8ro5EcuOKN0XTvYiOGW4WaORUBmJfLDC04K/hq/IuI4l+B/K10xi5rpxYe+iV6+Y90
 Ns3A1u7T5XkZ/uhq6QTxaCQz4V7WaS5PftunvqcK35OT3975qb+KDCubSMdp60AI9pu+Bse
 pYa2dHAaFkgFYNztVvLXA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2015 10:14:44 Yijing Wang wrote:
> >> I'm confused: the same code is already part of the PCI tree, but with
> >> Lorenzo Pieralisi listed as the patch author. The code is good,
> >> and I acked it in the past, but one of you is (probably by accident)
> >> misattributing the patch.
> >>
> >> Assuming that the patch that is already merged in next is the right
> >> one, I think you should rebase your series on top of
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git#next
> >>
> >> to avoid conflicts like this one.
> >>
> > 
> > I think I just got confused because the code duplicates most of
> > pci_bus_assign_domain_nr(). Maybe this can be done in a better way
> > by splitting the existing function into 
> > 
> > static int pci_assign_domain_nr(struct device *)
> > {
> >       ... /* most of pci_bus_assign_domain_nr */
> > 
> >       return domain;
> > }
> > 
> > void pci_host_assign_domain_nr(struct pci_host_bridge *host)
> > {
> >       host->domain = pci_assign_domain_nr(host->dev.parent);
> > }
> > 
> > void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
> > {
> >       bus->domain_nr = pci_assign_domain_nr(parent);
> > }
> > 
> 
> Hi Arnd,
>    I kept the almost duplicated pci_host_assign_domain_nr() and
> pci_bus_assign_domain_nr() here for building happy, because now
> platform specific pci_domain_nr() still exists which may get domain
> number from pci_bus. pci_bus_assign_domain_nr() will be removed in
> the last patch.
> 

I'm not sure I get your point: the approach I showed above seems to have
the same effect, except it doesn't duplicate code temporarily, which
makes it less error-prone in case your patch gets merged at the
same time as another patch that modifies pci_bus_assign_domain_nr.

	Arnd
