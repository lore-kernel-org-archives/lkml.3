Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaIANPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:15:10 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56772 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIANPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:15:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-mm-sig@lists.linaro.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring <robh@kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Inki Dae <inki.dae@samsung.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thierry Reding <treding@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com
Subject: Re: [Linaro-mm-sig] [PATCH 10/29] drivers: add DRIVER_HAS_OWN_IOMMU_MANAGER flag
Date: Mon, 01 Sep 2014 15:14:45 +0200
Message-ID: <2864762.XVyAv0xVzJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54046186.5030407@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com> <5493968.dbuSPSqts4@wuerfel> <54046186.5030407@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zWVZOgU+b/OTq242Ocp9Lfa48qWDXtH3Lq9Y4GOy6F9
 wEFdEJdQ2CS2lrJ0u2n1LKvfrlyUUIINCJVH+c0/1o7XHtefTh
 Yfq3dMUaL5T18pFssLmdW3HkJpukxIE1swgu4X9wNn2RqUFRG2
 zItZcr3OyuvaJBP/rCP778T3rTmw42Z3ybK54xZZjkad2ElkKm
 Hzucgcac/77zU4ZLfjkFq1oQAw0NQN5yrn6/x13hZULdfWlT//
 HK9tcu7Esk7tkQ8lE2mAxtlaPGtVzyJL5zPKsDspabqBmWcXSV
 N9eH4UNzEJF/C81XCLi/kkbuUSDCcOuYukPQxniFXK4GH3fXck
 0xNBFCIwvFA/LazEutbI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014 14:07:34 Marek Szyprowski wrote:
> On 2014-09-01 13:56, Arnd Bergmann wrote:
> > On Monday 01 September 2014 12:47:08 Marek Szyprowski wrote:
> >>> Who do you think needs to set this flag, and who needs to read it?
> >> In the proposed solution Exynos IOMMU driver creates a separate IO
> >> address space
> >> for every client device in a system and binds it to the default
> >> dma-mapping space
> >> for the given device. When drivers are doing its own management of IO
> >> address
> >> space, instead of relying on what is available by default with dma-mapping
> >> interface, this will require releasing of the previously created default
> >> structures and resources. So this flag is set by the driver doing its own
> >> management of io address space. The flags is then checked by Exynos
> >> IOMMU driver
> >> to avoid creating the default dma-mapping address space for devices
> >> which driver
> >> does its own management.
> > I don't completely understand it yet. I would assume the device
> > to be added to the default domain at device creation time
> > (of_platform_populate), way before we know which device driver
> > is going to be used. How can this prevent the iommu driver
> > from doing the association with the domain?
> 
> of_platform_populate() is too early to do the association, because that 
> time the
> exynos iommu driver is even not yet probed.

Please have a look at the "Introduce automatic DMA configuration for IOMMU
masters" series that Will Deacon sent out the other day. The idea is that
we are changing the probe order so that the iommu gets initialized early
enough for all IOMMU association to be done there.

> The association with default dma-mapping domain is done in
> IOMMU_GROUP_NOTIFY_BIND_DRIVER notifier, just before binding the driver 
> to the
> given device. This way iommu driver can check dev->driver->flags and 
> skip creating
> default dma-mapping domain if driver announces that it wants to handle it by
> itself.

I really want to kill off those notifiers.

	Arnd
