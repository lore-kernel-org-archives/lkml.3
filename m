Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab3FMELw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:11:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:62321 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab3FMELv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:11:51 -0400
Message-ID: <51B9467B.7080902@huawei.com>
Date: Thu, 13 Jun 2013 12:11:39 +0800
From: "Jiang Liu (Gerry)" <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, Roman Yepishev <roman.yepishev@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
References: <CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com> <CAE9FiQVqKag2TGah7x_1MAJ+c0UWgywgM_jKUoOnh+rq3bwBhg@mail.gmail.com> <CAE9FiQVMgdj5edbR4qZny29fV9-bW_We_G4Wpn_yruDLQZiQiQ@mail.gmail.com> <20130329032200.GA11990@google.com> <CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com> <CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com> <CAE9FiQXkDg7Y336S=DXoms44=5HLaiUx=sWviupz1fJmaDUEzQ@mail.gmail.com> <CAE9FiQU5c=ztzbskNnYFFKF9V5zO+jnRcMBCivLxA1F3fSfX5w@mail.gmail.com> <20130401235256.GA31966@google.com> <CAE9FiQV8cPh-s6=EQu_cZTtn86+NwZE5KuGMhf43aOhzkL=hwA@mail.gmail.com> <CAErSpo7Jni1ZSf_W=vB3kqsucPpoepa2Q5g=77a6D3FaPwe9LA@mail.gmail.com> <CAE9FiQWjQXwiTWju6cBc_o25jy_wmZ1u+Pifh1wdnxtV=i5ENw@mail.gmail.com> <CAErSpo7=a-wX6BLbm_O1nUMMrQHOgtSm3xZHKuRqaz8rnKSbRA@mail.gmail.com> <CAE9FiQUbw7OUhRB+gKMxkuE9+nm9097+mwZ2z4adO8Hv_NjF1Q@mail.gmail.com> <CAErSpo7gL3Ds9oq8ZZ4zdt1uHy9xbkWJE+Ja=-0QXFQECjr40A@mail.gmail.com>
In-Reply-To: <CAErSpo7gL3Ds9oq8ZZ4zdt1uHy9xbkWJE+Ja=-0QXFQECjr40A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.77.35]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,
     I'm working on several acpiphp related bugfixes, and feel some
are materials for 3.10 too. Actually we have identified four bugs
related to dock station support on Sony VAIO VPCZ23A4R laptop.
I will try to send out patchset to address these bugs tonight.
Seems we really need to rethink about acpiphp and pciehp now.
Regards!
Gerry
On 2013/6/13 11:50, Bjorn Helgaas wrote:
> On Wed, Jun 12, 2013 at 1:41 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Wed, Jun 12, 2013 at 10:05 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>> current code from acpi_pci_root_add we have
>>>>    1. pci_acpi_scan_root
>>>>           ==> pci devices enumeration and bus scanning.
>>>>               ==> pci_alloc_child_bus
>>>>                   ==> pcibios_add_bus
>>>>                       ==> acpi_pci_add_bus
>>>>                           ==> acpiphp_enumerate_slots
>>>>                               ==> ...==> register_slot
>>>>                                    ==> device_is_managed_by_native_pciehp
>>>>                                          ==> check osc_set with
>>>> OSC_PCI_EXPRESS_NATIVE_HP_CONTROL
>>>>     2. _OSC set request
>>>>
>>>> so we always have acpiphp hotplug slot registered at first.
>>>>
>>>> so either we need to
>>>> A. revert reverting about _OSC
>>>> B. move pcibios_add_bus down to pci_bus_add_devices()
>>>>      as acpiphp and apci pci slot driver are some kind of drivers for pci_bus
>>>> C. A+B
>>>
>>> It doesn't surprise me at all that there are problems in the _OSC code
>>> and the acpiphp/pciehp interaction.  That whole area is a complete
>>> disaster.  It'd really be nice if somebody stepped up and reworked it
>>> so it makes sense.
>>>
>>> But this report is useless to me.  I don't have time to work out what
>>> the problem is and how it affects users and come up with a fix.
>>
>> effects: without fix the problem, user can not use pcie native hotplug
>> if their system's firmware support acpihp and pciehp.
>> And make it worse, that acpiphp have to be built-in, so they have no
>> way to blacklist acpiphp in config.
>>
>>>
>>> My advice is to simplify the path first, and worry about fixing the
>>> bug afterwards.  We've already done several iterations of fiddling
>>> with things, and I think all we're doing is playing "whack-a-mole" and
>>> pushing the bugs around from one place to another.
>>
>> We need to address regression at first.
>> my suggestion is : revert the reverting and apply my -v3 version that will fix
>> regression that Roman Yepishev met.
>>
>> please check attached two patches, hope it could save your some time.
>
> OK, you're right.  It's not reasonable to do anything more than a
> minimal fix when we're at -rc5.
>
> Sigh.  I'll spend tomorrow trying to understand your patches and write
> changelogs for you.
>
> I think you're saying that in systems that support both acpiphp and
> pciehp, we should be using pciehp, but we currently use acpiphp.  If
> so, that's certainly a bug.  How serious is it?  Is it a disaster if
> we use acpiphp until we can resolve this cleanly?  Are there a lot of
> systems that claim to support acpiphp but it doesn't actually work?
>
> Bjorn
>
> .
>


