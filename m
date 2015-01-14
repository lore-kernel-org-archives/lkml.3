Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbbANKTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:19:30 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33636 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbbANKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:19:26 -0500
Message-ID: <54B642A6.7040201@arm.com>
Date: Wed, 14 Jan 2015 10:19:18 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v2 3/8] PCI/MSI: of: Add support for OF-provided msi_domain
References: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com> <1420736772-11088-4-git-send-email-marc.zyngier@arm.com> <54B62609.7020002@huawei.com>
In-Reply-To: <54B62609.7020002@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abel,

On 14/01/15 08:17, Yun Wu (Abel) wrote:
> On 2015/1/9 1:06, Marc Zyngier wrote:
> 
>> In order to populate the PHB msi_domain, use the "msi-parent"
>> attribute to lookup a corresponding irq domain. If found,
>> this is our MSI domain.
>>
>> This gets plugged into the core PCI code.
>>
> 
> Hi Marc,
> 
> Since the whole patch series based on the fact that non PCI type
> buses will use MSI-like interrupts, would it be better if getting
> this field settled during OF populating?

Are you're thinking of letting random platform devices automagically
gain an MSI domain as they are discovered by DT? I feel like you looking
at it the wrong way.

Note that DT discovery doesn't imply a particular bus, and non-PCI
doesn't mean bus-agnostic. MSI-like interrupts really are a bus
property, and I'd rather see you implementing support for your favourite
bus (and do the MSI domain matching there).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
