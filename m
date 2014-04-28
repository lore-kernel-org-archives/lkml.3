Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaD1TKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:10:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54325 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbaD1TKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:10:17 -0400
Message-ID: <535E9558.8010803@wwwdotorg.org>
Date: Mon, 28 Apr 2014 11:52:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        kgene.kim@samsung.com, Shaik Ameer Basha <shaik.ameer@samsung.com>,
        prathyush.k@samsung.com, grundler@chromium.org, joro@8bytes.org,
        supash.ramaswamy@linaro.org, linux-kernel@vger.kernel.org,
        pullip.cho@samsung.com, tomasz.figa@gmail.com, sachin.kamat@linaro.org,
        iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        s.nawrocki@samsung.com, a.motakis@virtualopensystems.com,
        Varun.Sethi@freescale.com, joshi@samsung.com, t.figa@samsung.com,
        rahul.sharma@samsung.com, Hiroshi Doyu <hdoyu@nvidia.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v12 11/31] documentation: iommu: add binding document
 of Exynos System MMU
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com> <4447051.OnJtcFSqFV@wuerfel> <20140428103919.GF19455@ulmo> <6544270.ddFBoY6LMm@wuerfel> <20140428111802.GI19455@ulmo>
In-Reply-To: <20140428111802.GI19455@ulmo>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 05:18 AM, Thierry Reding wrote:
> On Mon, Apr 28, 2014 at 12:56:03PM +0200, Arnd Bergmann wrote:
...
>> A lot of drivers probably only support one
>> master, so they can just set #iommu-cells=<0>, others might require
>> IDs that do not fit into one cell.
> 
> You mean "#iommu-cells = <1>" for devices that only require one master?
> There still has to be one cell to specify which master. Unless perhaps
> if they can be arbitrarily assigned. I guess even if there's a fixed
> mapping that applies to one SoC generation, it might be good to still
> employ a specifier and have the mapping in DT for flexibility.

#iommu-cells doesn't include the phandle, so if you want the client
references to be:

property = <&iommu>;

then that's #iommu-cells=<0>, whereas:

property = <&iommu N>;

is #iommu-cells=<1>.


