Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3FZX4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:56:06 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60144 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3FZX4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:56:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo68p7_0zsnBjD=sb14vs0QyCZuN+RTvib2-ZOYUiZn6pw@mail.gmail.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
	<1372177330-28013-7-git-send-email-mika.westerberg@linux.intel.com>
	<CAErSpo58bCG4=hwC73VY+nXPk9-dZUb5eWERZ_wTtAfrXtBVmg@mail.gmail.com>
	<CAE9FiQW9xuu6WjH59td6Jve10kokoxU4mNqj4DRyg7beqBzHDA@mail.gmail.com>
	<CAE9FiQVCQKjPa1dVKhAubvD+d=rudOxLaRMYAr-GAC7eSSz09Q@mail.gmail.com>
	<CAErSpo68p7_0zsnBjD=sb14vs0QyCZuN+RTvib2-ZOYUiZn6pw@mail.gmail.com>
Date: Wed, 26 Jun 2013 16:56:03 -0700
X-Google-Sender-Auth: C-WDNtAJYqVrqXi-8tpCyOOsb94
Message-ID: <CAE9FiQVm-gABPsh1-A8H+a0Prug7JMoQpwvKC2EKHpQVXOhzcA@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86/PCI: quirk Thunderbolt PCI-to-PCI bridges
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 3:55 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Jun 26, 2013 at 4:31 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Wed, Jun 26, 2013 at 3:26 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Wed, Jun 26, 2013 at 3:18 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>> On Tue, Jun 25, 2013 at 10:22 AM, Mika Westerberg
>>>> <mika.westerberg@linux.intel.com> wrote:
>>>>> Thunderbolt PCI-to-PCI bridges typically use BIOS "assisted" enumeration.
>>>>> This means that the BIOS will allocate bridge resources based on some
>>>>> assumptions of a maximum Thunderbolt chain. It also disables native PCIe
>>>>> hotplug of the root port where the Thunderbolt host router is connected.
>> ...
>> During acpi hotplug, firmare could do extra help for us like assign
>> some resources to pci device bars, so it is NOT "boot-time".
>
> Really?  How can firmware assign BARs at hotplug-time?  I mean,
> obviously firmware *can* write things to the BARs before giving the
> device to the OS, but how would it know what to write?

should be acpi code, or SMI code or even BMC firmware via sideband.

>  I assume the
> OS owns the address space, and it can change the upstream bridge
> windows or the BARs of another device on the bus at any time, subject
> to the OS's own issues as far as quiescing or unbinding drivers, etc.,
> but without coordinating with the BIOS.

for thunderbolt or dock with acpiphp, then all children devices/bridges should
not have drivers loaded yet.

Yinghai
