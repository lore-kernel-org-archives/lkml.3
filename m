Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaAOSiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:38:04 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:59309 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbaAOSh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:37:58 -0500
Message-ID: <52D6C185.2090303@epfl.ch>
Date: Wed, 15 Jan 2014 18:12:37 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Anna, Suman" <s-anna@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Tony Lindgren <tony@atomide.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <bcousson@baylibre.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/7] iommu/omap: Do bus_set_iommu() only if probe() succeeds
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-2-git-send-email-florian.vaussard@epfl.ch> <52B888C2.8040303@ti.com> <52B8A5F8.3000706@epfl.ch> <52B8C8C1.8080101@ti.com>
In-Reply-To: <52B8C8C1.8080101@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

So back to this...

On 12/24/2013 12:35 AM, Anna, Suman wrote:
> Hi Florian,
> 

[...]

>>
>> If omap_iommu_probe() fails, the init will have called bus_set_iommu()
>> anyways. Thus, when a driver request the iommu by calling
>> iommu_domain_alloc(), it will succeed (but iommu_attach_device() will
>> fail if I remember).
> 
> Yeah, thats the behavior I expected anyway.
> 
>> Leaving a driver with a dangling reference to
>> a phantom iommu is not good IMHO. It will lead to strange behaviours
>> one day or another.
>>
>> As for the multiple iommu case, as I do not think it is currently
>> possible, as bus_type (in this case &platform_bus_type) has only
>> one struct iommu_ops. bus_set_iommu() will return EBUSY on the
>> second call. Am I missing something?
> 
> What I meant was the problem you cited will still exist, say if ISP MMU
> probe failed, but the IVA MMU probe succeeded. The bus_set_iommu() can
> only be called once anyway, so moving it from init to probe would not
> help much.
> 

Ok I see your point. Similar IPs share the same ops, but with different
omap_iommu_arch_data, even if currently we only have one registered
IOMMU for OMAP3.

So I will drop this patch.

Regards,
Florian
