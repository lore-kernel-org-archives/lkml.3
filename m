Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbaKRPr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:47:58 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34949 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbaKRPr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:47:56 -0500
MIME-Version: 1.0
In-Reply-To: <BC567D27D6B7384F84318942321624DE16179F2A@hasmsx109.ger.corp.intel.com>
References: <1415847123-15558-1-git-send-email-michael.jamet@intel.com>
 <CAErSpo7Z5x=U3vSnxrFpwYUDrUrnrrBCe1F9_GQNYqWWQFWNpQ@mail.gmail.com>
 <CAHp75VcZ0XjcFxjrSgr5-XnWZZa-eZfPH_Fa1Hzb=f+qtE3z9w@mail.gmail.com>
 <CAMxnaaXOa_GAFwK+tUrO8DBjENqdd9uaQHKqEMm+i4754Ch3gQ@mail.gmail.com> <BC567D27D6B7384F84318942321624DE16179F2A@hasmsx109.ger.corp.intel.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Tue, 18 Nov 2014 16:47:35 +0100
Message-ID: <CAMxnaaV41H-bzw2kp=HXd0aicRJbtNJuNE4aPf=EvQPMKiPQ6g@mail.gmail.com>
Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O resources.
To: "Jamet, Michael" <michael.jamet@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Levy, Amir (Jer)" <amir.jer.levy@intel.com>,
        "Alloun, Dan" <dan.alloun@intel.com>,
        Rafael Wysocki <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 9:20 AM, Jamet, Michael <michael.jamet@intel.com> wrote:
>> -----Original Message-----
>> From: Andreas Noever [mailto:andreas.noever@gmail.com]
>> Sent: Wednesday, November 12, 2014 22:19
>> To: Andy Shevchenko
>> Cc: Bjorn Helgaas; Jamet, Michael; linux-pci@vger.kernel.org; linux-
>> kernel@vger.kernel.org; Levy, Amir (Jer); Alloun, Dan; Rafael Wysocki
>> Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O
>> resources.
>>
>> On Wed, Nov 12, 2014 at 7:30 PM, Andy Shevchenko
>> <andy.shevchenko@gmail.com> wrote:
>> > On Wed, Nov 12, 2014 at 7:29 PM, Bjorn Helgaas <bhelgaas@google.com>
>> wrote:
>> >
>> > []
>> >
>> >>> To prevent this, we detect a chain contains a Thunderbolt device by
>> >>> checking the Thunderbolt PCI device id.
>> >>
>> >> I'm really not happy about checking a list of device IDs to identify
>> >> Thunderbolt devices.  Surely there's a better way, because a list
>> >> like this has to be updated regularly.
>> >
>> > I recently proposed internally to use quirks (pci_fixup_early) for
>> > that, but apparently Michael didn't have time to answer. It might be
>> > he can just comment here since the patch already public.
>>
>> In any case: this will interfere with thunderbolt hotplug on Apple systems,
>> where we do not have BIOS support and have to handle hotplug events and
>> assign resources ourselves. So please add a DMI check for Apple (the reverse
>> of what we do in
>> http://lxr.free-
>> electrons.com/source/drivers/thunderbolt/nhi.c?v=3.17#L664
>> ).
>>
>> Thanks,
>> Andreas
>
> This is correct that the hotplug handling mechanism and interaction with BIOS is different.
> However, this patch also applies for any case, since the I/O space is limited
> and need to be preserved, so we must prevent allocation of I/O resources
> from the devices and avoiding exhaustion while chaining them.

Now I am slightly confused. Does the BIOS (on non Apple hardware)
leave I/O resources always unassigned? Your first post seemed to imply
that it does assign some and that we should not interfere. In that
case we would have to assign them on Apple systems ourselves. On the
other hand if no TB device uses I/O resources and the BIOS never
assigns them, then why do devices fail if we exhaust them?

Andreas




> Michael
>
>
> ---------------------------------------------------------------------
> Intel Israel (74) Limited
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
