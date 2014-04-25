Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaDYQoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:44:17 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:45038 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaDYQoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:44:15 -0400
MIME-Version: 1.0
In-Reply-To: <e760e15b4f404c6cb3252480a7d8a78a@CO1PR05MB523.namprd05.prod.outlook.com>
References: <5339FF99.2050200@gmail.com> <20140424213106.GI29593@google.com> <e760e15b4f404c6cb3252480a7d8a78a@CO1PR05MB523.namprd05.prod.outlook.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 25 Apr 2014 10:43:54 -0600
Message-ID: <CAErSpo4ymkPOx5Evi=nctWr5f7OY6vkQTzwGnvi1ck7t-OTAWg@mail.gmail.com>
Subject: Re: [PATCH] pci/pciehp: Allow polling/irq mode to be decided on a
 per-port basis
To: Guenter Roeck <groeck@juniper.net>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 10:34 AM, Guenter Roeck <groeck@juniper.net> wrote:
>
>
>> -----Original Message-----
>> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> Sent: Thursday, April 24, 2014 2:31 PM
>> To: Rajat Jain
>> Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; Rajat
>> Jain; Guenter Roeck
>> Subject: Re: [PATCH] pci/pciehp: Allow polling/irq mode to be decided
>> on a per-port basis
>>
>> On Mon, Mar 31, 2014 at 04:51:53PM -0700, Rajat Jain wrote:
>> > Today, there is a global pciehp_poll_mode module parameter using
>> which
>> > either _all_ the hot-pluggable ports are to use polling, or _all_ the
>> > ports are to use interrupts.
>> >
>> > In a system where a certain port has IRQ issues, today the only
>> option
>> > is to use the parameter that converts ALL the ports to use polling
>> mode.
>> > This is not good, and hence this patch intruduces a bit field that
>> can
>> > be set using a PCI quirk that indicates that polling should always be
>> > used for this particular PCIe port. The remaining ports can still
>> > hoose to continue to operate in whatever mode they wish to.
>> >
>> > Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
>> > Signed-off-by: Rajat Jain <rajatjain@juniper.net>
>> > Signed-off-by: Guenter Roeck <groeck@juniper.net>
>>
>> I'm willing to merge this, but I'd prefer to merge it along with a
>> quirk that actually sets dev->hotplug_polling.  Otherwise it's dead
>> code and I'll have no way to tell whether we need to keep it.
>>
> Bjorn,
>
> what would be the proper location for such a quirk ?
> We use it to help simulating hotplug support on an IDT PES12NT3.
> The code is a bit more invasive than just the quirk itself,
> since it also needs to touch link and slot status registers,
> so quirks.c doesn't seem appropriate.
>
> drivers/pci/pes12nt3.c, maybe, with a separate configuration
> option ? Or in the hotplug directory ?

If this is only for debug, i.e., you don't intend to ship a product
using this simulated hotplug, maybe you should just keep both the
quirk and this patch out of tree.

If you do want to eventually ship this code for some product, I think
it'd be fine to put the quirk in drivers/pci/quirks.c, maybe with a
config option to enable it.  But without seeing the quirk, I can't
really tell.  A new file seems overkill unless it's something really
huge -- I don't think we really have examples of dedicated files for
other chip idiosyncrasies.

Bjorn
