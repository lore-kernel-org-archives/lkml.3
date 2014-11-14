Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935086AbaKNBUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:20:55 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:13880 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934683AbaKNBUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:20:52 -0500
Message-ID: <546558B9.1020708@huawei.com>
Date: Fri, 14 Nov 2014 09:19:53 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, <suravee.suthikulpanit@amd.com>
CC: <liviu.dudau@arm.com>, <lorenzo.pieralisi@arm.com>, <will.deacon@arm.com>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/2] PCI: generic: Assiging msi-controller to PCI hostbridge
References: <1415733454-24322-1-git-send-email-suravee.suthikulpanit@amd.com> <20141113180959.GR5064@google.com>
In-Reply-To: <20141113180959.GR5064@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/14 2:09, Bjorn Helgaas wrote:
> [+cc Yijing]

Hi, I'm doing the same thing to associate MSI_controller and PCI host bridge(not PCI bus),
In my working series, I go one step further, rip out pci host bridge of pci root bus creation.
And we could put the common things in the generic pci host bridge. I will post it out these
days. :)

Thanks!
Yijing.

> 
> On Tue, Nov 11, 2014 at 01:17:32PM -0600, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> This patch set introduces a new callback function to allow PCI host drivers
>> to specify MSI controller to be used for the child buses / devices.
> 
> Hi Suravee, 
> 
> As Srikanth mentioned, there's a series of MSI-related stuff from Yijing.
> I recently put them on my pci/msi branch, and they overlap a bit with
> what you're doing here.
> 
> So I'll drop these for now.  Maybe there's a way you can accomplish what
> you need by implementing pcibios_msi_controller(), which Yijing added?
> 
> Also note that "msi-controller" is already being used in device tree (see
> Documentation/devicetree/bindings/interrupt-controller/marvell), so maybe
> you can do the name.
> 
> Bjorn
> 
>> This is reabased from:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/host-generic
>>
>> Changes from V1:
>>     - Adding "msi-parent" device tree binding in documentation.
>>     - Rebase the patch to get rid of artifacts from other precursor patch
>>       accidently applied to the developement tree. This should now apply cleanly
>>       to the pci/host-generic branch.
>>
>> Suravee Suthikulpanit (2):
>>   PCI: Add new pci_ops for setting MSI parent for PCI bus
>>   PCI: generic: Add set_msi_parent callback
>>
>>  Documentation/devicetree/bindings/pci/host-generic-pci.txt |  3 +++
>>  drivers/pci/host/pci-host-generic.c                        | 13 +++++++++++++
>>  drivers/pci/probe.c                                        |  3 +++
>>  include/linux/pci.h                                        |  1 +
>>  4 files changed, 20 insertions(+)
>>
>> -- 
>> 1.9.3
>>
> 
> .
> 


-- 
Thanks!
Yijing

