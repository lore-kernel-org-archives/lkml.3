Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaKLUT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:19:27 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44939 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbaKLUT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:19:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAHp75VcZ0XjcFxjrSgr5-XnWZZa-eZfPH_Fa1Hzb=f+qtE3z9w@mail.gmail.com>
References: <1415847123-15558-1-git-send-email-michael.jamet@intel.com>
 <CAErSpo7Z5x=U3vSnxrFpwYUDrUrnrrBCe1F9_GQNYqWWQFWNpQ@mail.gmail.com> <CAHp75VcZ0XjcFxjrSgr5-XnWZZa-eZfPH_Fa1Hzb=f+qtE3z9w@mail.gmail.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Wed, 12 Nov 2014 21:19:05 +0100
Message-ID: <CAMxnaaXOa_GAFwK+tUrO8DBjENqdd9uaQHKqEMm+i4754Ch3gQ@mail.gmail.com>
Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O resources.
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Michael Jamet <michael.jamet@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        amir.jer.levy@intel.com, dan.alloun@intel.com,
        Rafael Wysocki <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 7:30 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Wed, Nov 12, 2014 at 7:29 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> []
>
>>> To prevent this, we detect a chain contains a Thunderbolt
>>> device by checking the Thunderbolt PCI device id.
>>
>> I'm really not happy about checking a list of device IDs to identify
>> Thunderbolt devices.  Surely there's a better way, because a list like
>> this has to be updated regularly.
>
> I recently proposed internally to use quirks (pci_fixup_early) for
> that, but apparently Michael didn't have time to answer. It might be
> he can just comment here since the patch already public.

In any case: this will interfere with thunderbolt hotplug on Apple
systems, where we do not have BIOS support and have to handle hotplug
events and assign resources ourselves. So please add a DMI check for
Apple (the reverse of what we do in
http://lxr.free-electrons.com/source/drivers/thunderbolt/nhi.c?v=3.17#L664
).

Thanks,
Andreas
