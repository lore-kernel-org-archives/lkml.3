Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3LPSme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:42:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33644 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3LPSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:42:33 -0500
Message-ID: <52AF4993.80406@wwwdotorg.org>
Date: Mon, 16 Dec 2013 11:42:27 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>, swarren@nvidia.com, will.deacon@arm.com,
        grant.likely@linaro.org, thierry.reding@gmail.com,
        robherring2@gmail.com, joro@8bytes.org
CC: mark.rutland@arm.com, devicetree@vger.kernel.org,
        lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, galak@codeaurora.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv7 05/12] iommu/core: add ops->{bound,unbind}_driver()
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com> <1386835033-4701-6-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1386835033-4701-6-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 12:57 AM, Hiroshi Doyu wrote:
> ops->{bound,unbind}_driver() functions are called at
> BUS_NOTIFY_{BOUND,UNBIND}_DRIVER respectively.

Some explanation re: why the existing {add,remove}_device hooks aren't
enough would be useful. I didn't really get that from the current commit
description. What actions would an IOMMU driver take in these new
callbacks that could not be taken in {add,remove}_device? Surely the
IOMMU could set up any internal data structures, AS, or page tables,
etc. within add_device, rather than deferring to bound_driver, which
presumably happens after the device's probe(), yet the driver might want
to make the HW do bus-master accesses within probe(), or at least map
stuff into the page table...

> This is necessary to control the device population order. IOMMU master
> devices depend on an IOMMU device instanciation. IOMMU master devices

Is an "IOMMU master device" the device that issues transactions on the
bus, which are affected by the IOMMU? The more common term for this is
"bus master"; "IOMMU master device" sounds too similar to the "IOMMU"
itself.
