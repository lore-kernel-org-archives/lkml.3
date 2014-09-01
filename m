Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaIAL5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:57:11 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:53698 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaIAL5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:57:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, Thierry Reding <treding@nvidia.com>,
        Rob Herring <robh@kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>
Subject: Re: [PATCH 10/29] drivers: add DRIVER_HAS_OWN_IOMMU_MANAGER flag
Date: Mon, 01 Sep 2014 13:56:42 +0200
Message-ID: <5493968.dbuSPSqts4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54044EAC.6010701@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com> <4621634.jlJLccozTJ@wuerfel> <54044EAC.6010701@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IStdDFlY6kZAXGVP3Cy6CvrAue3cGxGb8gUjcPCPLhs
 qcRoBjxc16pqYc3J3JRIt8ffOB9eYuxEPTT+jvXb11zaQLF8zI
 WRnqv2ymoQDdhb8wnp3KIvsySyvccHu+3fY9G3NGsRuw3eY7Dk
 hOg+OtnLqfQote4BEUmX13UlXi9zCfgbsjSrk3JPILY0xPVeU5
 9mX3wIGAHVxf6oXDb3oWQmm6aEeKyMGf3H0/sRVrfGsA8O4FHB
 iNvlHCqcDCy20PKvmoCFGo8JT9LJxTJzFElRL85T36QtxiG+Up
 42wQqLjhNZRBPxixy53yftNa1l/yaCRNYBQp9cjYjXqtD5/Ayr
 oa+kYEMSC3vdTp5JCpEA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014 12:47:08 Marek Szyprowski wrote:
> > Who do you think needs to set this flag, and who needs to read it?
> 
> In the proposed solution Exynos IOMMU driver creates a separate IO 
> address space
> for every client device in a system and binds it to the default 
> dma-mapping space
> for the given device. When drivers are doing its own management of IO 
> address
> space, instead of relying on what is available by default with dma-mapping
> interface, this will require releasing of the previously created default
> structures and resources. So this flag is set by the driver doing its own
> management of io address space. The flags is then checked by Exynos 
> IOMMU driver
> to avoid creating the default dma-mapping address space for devices 
> which driver
> does its own management.

I don't completely understand it yet. I would assume the device
to be added to the default domain at device creation time
(of_platform_populate), way before we know which device driver
is going to be used. How can this prevent the iommu driver
from doing the association with the domain?

	Arnd
