Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaKRP6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:58:50 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:59724 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbaKRP6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:58:48 -0500
MIME-Version: 1.0
In-Reply-To: <BC567D27D6B7384F84318942321624DE16179E60@hasmsx109.ger.corp.intel.com>
References: <1415847123-15558-1-git-send-email-michael.jamet@intel.com>
 <CAErSpo7Z5x=U3vSnxrFpwYUDrUrnrrBCe1F9_GQNYqWWQFWNpQ@mail.gmail.com> <BC567D27D6B7384F84318942321624DE16179E60@hasmsx109.ger.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Nov 2014 08:58:28 -0700
Message-ID: <CAErSpo5z41ZOL3xUwwSZ8UE_KGmCDOUmFQ3CY_QwF7JVhU1-EQ@mail.gmail.com>
Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O resources.
To: "Jamet, Michael" <michael.jamet@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Levy, Amir (Jer)" <amir.jer.levy@intel.com>,
        "Alloun, Dan" <dan.alloun@intel.com>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Andreas Noever <andreas.noever@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 12:57 AM, Jamet, Michael
<michael.jamet@intel.com> wrote:
>> -----Original Message-----
>> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> Sent: Wednesday, November 12, 2014 19:29
>> To: Jamet, Michael
>> Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; Levy, Amir
>> (Jer); Alloun, Dan; Rafael Wysocki; Andreas Noever
>> Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O
>> resources.
>>
>> [+cc Rafael, Andreas]
>>
>> On Wed, Nov 12, 2014 at 7:52 PM, Michael Jamet
>> <michael.jamet@intel.com> wrote:
>> > Every Thunderbolt-based devices or Thunderbolt-connected devices
>> > should not allocate PCI I/O resources per Thunderbolt specs.
>>
>> Please include a pointer to those specs in the changelog.
>>
>
> Unfortunately these specs are not publically available.
>
>> > On a Thunderbolt PC, BIOS is responsible to allocate IO resources.
>> > Kernel shouldn't allocate the PCI I/O resources as it interferes with
>> > BIOS operation.
>> > Doing this may cause the devices in the Thunderbolt chain not being
>> > detected or added, or worse to stuck the Thunderbolt Host controller.
>>
>> These new kernel/firmware coordination requirements need to be
>> documented.  If they're already part of a PCIe ECN or PCI firmware spec, just
>> provide a pointer.
>>
>
> Same, this refers to same specs.
>
>> > To prevent this, we detect a chain contains a Thunderbolt device by
>> > checking the Thunderbolt PCI device id.
>>
>> I'm really not happy about checking a list of device IDs to identify
>> Thunderbolt devices.  Surely there's a better way, because a list like this has
>> to be updated regularly.
>>
>> Bjorn
>>
>
> This was also discussed internally and the only way to identify Thunderbolt devices is to check the device IDs.
> As you said, this will require us to maintain and keep the list up-to-date as we deliver new devices.

I don't really see how this can work.  You're asking me to put changes
based on a secret spec into generic code that is used on every machine
with PCI.  I have no way to maintain something like that.

This seems like a major screw up in the design and documentation of Thunderbolt.

Bjorn
