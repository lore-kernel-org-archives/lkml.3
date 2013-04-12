Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3DLBFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:05:08 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:13312 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3DLBFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:05:03 -0400
Message-ID: <51675DAD.8070009@huawei.com>
Date: Fri, 12 Apr 2013 09:04:45 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <liuj97@gmail.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v8 10/13] PCI/acpiphp: do not use ACPI PCI subdriver mechanism
References: <1361892353-14786-1-git-send-email-jiang.liu@huawei.com> <1361892353-14786-11-git-send-email-jiang.liu@huawei.com> <CAErSpo4uyqPRDWKvH_3rtnGzbro1+_SnGH9GBU_-tz1p2a+AMQ@mail.gmail.com> <51658FCB.3030906@gmail.com> <CAErSpo7O1L2aRc2aVSqwj2CKwwoC9dbFWgukNj=jCkG-PjYOMA@mail.gmail.com> <516616F0.6040508@huawei.com> <CAErSpo7=BoNAXQ_shm8M8FoLuZPVJGK9k5-LQhX4X30sFoaWjg@mail.gmail.com>
In-Reply-To: <CAErSpo7=BoNAXQ_shm8M8FoLuZPVJGK9k5-LQhX4X30sFoaWjg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/12 1:29, Bjorn Helgaas wrote:
> On Wed, Apr 10, 2013 at 7:50 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>>>> Hi Bjorn,
>>>>         Thanks for review.
>>>>
>>>>> My goal is that a user should never have to specify a kernel boot
>>>>> parameter or edit a modules.conf file, but the user did previously
>>>>> have some way to influence whether we use pciehp or acpiphp.  I know
>>>>> we still have some issues, particularly with acpiphp, so I'm a little
>>>>> concerned that by removing the CONFIG_HOTPLUG_PCI_ACPI=m, we might be
>>>>> removing a way to work around those issues.
>>>>>
>>>>> A distro that previously used CONFIG_HOTPLUG_PCI_ACPI=m will now have
>>>>> to use =y, so modules.conf is no longer applicable.  Can you convince
>>>>> me that the user still has a way to work around issues?  I spent quite
>>>>> a while trying to understand the pciehp/acpiphp dependencies, but it's
>>>>> pretty tangled web.
>>>> I will try my best to explain the relationships between pciehp and acpiphp
>>>> as of v3.9-rc6.
>>>>
>>>> The pciehp driver always have priority over the acpiphp driver.
>>>> That is, the acpiphp driver rejects binding to an ACPI PCI hotplug slot if
>>>> a) The slot's parent is a PCIe port with native hotplug capability
>>>> b) OSPM has taken over PCIe native hotplug control from BIOS.
>>>>         !(root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL)
>>>> The above check has no dependency on the loading order of pciehp and acpiphp
>>>> drivers. So converting acpiphp driver to builit-in should be ok.
>>>>
>>>> On the other hand, I remember Yinghai has mentioned that some PCIe ports
>>>> with native hotplug capability doesn't work as expected with the pciehp driver
>>>> and should be managed by the acpiphp driver. Currently we could achieve that
>>>> by using boot param "pcie_ports=compat", but this will disable PCIe port
>>>> drivers altogether. And I also remember that Rafael has mentioned that
>>>> some BIOSes exhibit strange dependency among PCIe OSC controls, so it's
>>>> not feasible to only disable PCIe native hotplug.
>>>>
>>>> For "pciehp_force", it does only affect the way pciehp to detect a hotplug
>>>> slot, it doesn't affect acpiphp at all.
>>>>
>>>> To sum up, converting acpiphp as built-in should not affect the relationship
>>>> between pciehp and acpiphp driver.
>>>
>>> My concern is that a user used to be able to remove acpiphp from
>>> modules.conf.  Now removing acpiphp will require a kernel rebuild.
>>> But maybe that won't turn out to be a problem.
>>
>> Hi Bjorn,
>>    If user don't want to occupy the slot by acpiphp. Conservative approach, what about add a kernel parameter
>> to control acpiphp to enumerate slot ?
> 
> Yes, that's what I'm thinking.  A "Please report a bug if you have to
> use this parameter" chicken switch.  Hopefully nobody will need to use
> it, but if somebody *does* need it, it's a lot better than having to
> tell him to rebuild the kernel.

Yes, I agree. We will add this patch to the patchset and resend soon.

Thanks!
Yijing.

> 
> Bjorn
> 
> .
> 


-- 
Thanks!
Yijing

