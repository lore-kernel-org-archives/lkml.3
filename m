Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3AKSGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:06:52 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:37221 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab3AKSGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:06:51 -0500
MIME-Version: 1.0
In-Reply-To: <17637668.59BS4lW4dN@vostro.rjw.lan>
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com>
 <1410202.K95a8u1BYT@vostro.rjw.lan> <CAE9FiQVmDW__C3A1_JJZpCZJwYWONZpHbzitMxsHZBxotw8VBA@mail.gmail.com>
 <17637668.59BS4lW4dN@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 11 Jan 2013 11:06:29 -0700
Message-ID: <CAErSpo6eB=Gn6wPBK=_KYhP=NOi26AmuJd_rS-zAw+2ERdrcew@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] ACPI/pci_slot: update PCI slot information when
 PCI hotplug event happens
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>, Myron Stowe <mstowe@redhat.com>,
        Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 4:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, January 10, 2013 03:40:45 PM Yinghai Lu wrote:
>> On Thu, Jan 10, 2013 at 3:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Thursday, January 10, 2013 03:03:53 PM Yinghai Lu wrote:
>> >> On Thu, Jan 10, 2013 at 1:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> > Well, I don't see what functional problems that can bring.
>> >> >
>> >> > In theory people may want to have them as modules to avoid loading them on
>> >> > systems that don't use PCI hotplug, but honestly I think that the complexity
>> >> > this causes us to deal with is not worth it.
>> >> >
>> >> > Moreover, removing the modularity may actually allow us to solve some ordering
>> >> > issues once and for good.
>> >>
>> >> No, the world is not really ideal yet.
>> >>
>> >> looks like laptops have problem with pci express cards.
>> >>
>> >> when pciehp is used, surprise insert/removal does not work because
>> >> PresDect does not change properly, so no interrupt is generated.
>> >> --- i suspects that is silicon problem.
>> >>
>> >> but when acpiphp is used, that surprise  insert/removal is working.
>> >>
>> >> some laptop like thinkpad, just don't give osc to kernel..
>> >> [    0.505117]  pci0000:00: Requesting ACPI _OSC control (0x1d)
>> >> [    0.505413]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT),
>> >> returned control mask: 0x0d
>> >> [    0.505517] ACPI _OSC control for PCIe not granted, disabling ASPM
>> >>
>> >> and other laptop give that to kernel, in recent kernel will not give
>> >> acpiphp to have that slot, because it want to hold that for pciehp.
>> >> poor user have to pass 'pci_aspm=off" to disable _OSC for all.
>> >> --- please check the mail that i forward to you yesterday.
>> >
>> > Yes, this is a bug, but I'm not sure how to fix it yet.
>>
>> add one command line to control it so do not claim that in osc_control?
>
> That's one option, although not very attractive so to speak.
>
>> >> Anyway, we do need to let the user to have choice to use acpiphp and pciehp.
>> >> and it should be first come and first serve policy.
>> >
>> > And that's why you think they should be modules?  I disagree if so.
>>
>> Yes.
>>
>> maybe we can have pci=nopciehp in command line just we pci=noaer...
>>
>> that should handle some corner cases.
>
> Yes.  In any case the user should be able to say "I know better", but having
> to express that through the "right" ordering of modules is somewhat less than
> straightforward in my opinion.

I think it's fine if a user *can* override the default ordering.

I am completely opposed to *requiring* a user to supply a command line
option or change the order of module loading just to get hotplug to
work.  There's no sane way to document that or communicate that
information to users.

Bjorn
