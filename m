Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbbAPJhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:37:35 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:59553 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbbAPJhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:37:11 -0500
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
Subject: Re: [PATCH 11/28] PCI: Introduce pci_host_bridge_ops to setup host bridge
Date: Fri, 16 Jan 2015 10:35:30 +0100
Message-ID: <3832604.lYie7PXiOd@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1443278.UW4hQ0rXtr@wuerfel>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-12-git-send-email-wangyijing@huawei.com> <1443278.UW4hQ0rXtr@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:uiuX5cgomu0DQnvoKQW7BjSPZyJX8U+3EuA1yUFH3hpWd6cbLaY
 zq9TBzp7m6iCBQ8glzp7rVfyJy5JMnkuxqT9HweGBD6mU07Y1hCJMHVVt+uebCMApV6H0bY
 Nt2doLTm0fUQ07ErTgtNTbBgLivt5efVQ4VSDRGn4lMvHYOoBuJvw0QDMJzSanzdn+y/gjS
 n33gENTNCnubtnU/Uvwug==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 10:23:11 Arnd Bergmann wrote:
> On Friday 16 January 2015 09:44:09 Yijing Wang wrote:
> > @@ -2064,7 +2073,7 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, u32 db,
> >  {
> >         struct pci_host_bridge *host;
> >  
> > -       host = pci_create_host_bridge(parent, db, resources, sysdata);
> > +       host = pci_create_host_bridge(parent, db, resources, sysdata, NULL);
> >         if (!host)
> >                 return NULL;
> >  
> > 
> 
> Same comment as for patch 10: If we leave this out of the pci_create_host_bridge
> argument but set it later, þe interface becomes simpler for callers that
> don't have custom pci_host_bridge_ops.
> 
> This would break your phb_prepare() callback, but I assume a host driver
> can just make a direct function call before entering pci_create_host_bridge
> for this. Let me know if I'm missing something here.

I've read the later patches now that explain why it's needed, so nevermind
my comment above.

	Arnd
