Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab3FGMAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:00:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59048 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab3FGL75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:59:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Andrew Murray'" <andrew.murray@arm.com>
Subject: Re: [PATCH 6/6] ARM: dts: Add pcie controller node for Samsung EXYNOS5440 SoC
Date: Fri, 07 Jun 2013 13:59:43 +0200
Message-ID: <1880458.2ksb8qtzHh@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <000c01ce6360$237a7040$6a6f50c0$@samsung.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com> <20130408165626.GA30824@obsidianresearch.com> <000c01ce6360$237a7040$6a6f50c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:siNPJ+SzUJyR/dBkvqE5CNkswV1k9p7jnGSxbP29BmS
 jITPiFwVaeCI5YpoGvp2STMhbL2O8nN+AQz3X4xxYkP99HHefL
 e6hIdYdE14ucK1SXhNXs0VCjkSFDJANq2Xh5CciW3olh5PWsgW
 WbRrpMZ/JUKxTWCZ3quRFQZRwXY/1Kyv4b+y/nbUR5p6vWNcJz
 jHaZKLyfmIwr/13jkkNJTxe7AJKAtf+rZ6su6yN+9R7ioOYvde
 XQcOgBul8zf6mc+xBUgHEj9zE9lk9syaFVprGV8Dh2WLATimHh
 V5NKRW4ruZTNqGE1iZtn8ZViEhV6T+gBMaS+MhNok/xn0Ger9u
 aWyNnxqAzOQyFEp8kkkE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013 18:19:40 Jingoo Han wrote:
> Hi Jason Gunthorpe,
> 
> I implemented 'Single domain' with Exynos PCIe for last two months;
> however, it cannot work properly due to the hardware restriction.
> Each MEM region is hard-wired.
> 
> Thus, I will send Exynos PCIe V3 patch as 'Separate domains'.

Yes, I think that is best, if the hardware is clearly designed as
separate domains, this is what we should do by default in the
driver. For the Marvell case with its 10 separate ports, much
more address space would be wasted by having one domain per
port and that hardware let us work around it by remapping the
physical address space windows. For Exynos there is much less to
lose and I too cannot see how it would be done in the first
place.

	Arnd
