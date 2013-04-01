Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab3DASPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:15:33 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:43988 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3DASPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:15:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUWL1+EUf2HZ3CXR87vuUCEE5BCLE18ZP2oE6Eo+_Ueiw@mail.gmail.com>
References: <1364444885-19751-1-git-send-email-yinghai@kernel.org>
 <1364444885-19751-3-git-send-email-yinghai@kernel.org> <CAErSpo7+V8vU8x2=MfZw3V7XsXKzs6qrvv8G=MqrEdUKcyvoTw@mail.gmail.com>
 <CAE9FiQUWL1+EUf2HZ3CXR87vuUCEE5BCLE18ZP2oE6Eo+_Ueiw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 1 Apr 2013 12:15:11 -0600
Message-ID: <CAErSpo6GTArwivZ=UJox_Laww3zE0rccYt2W4tiwAkSGdT6YYg@mail.gmail.com>
Subject: Re: [PATCH 2/2] eisa, PCI: init eisa early before pnp step in
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Whitehead <mwhitehe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 6:18 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Mar 29, 2013 at 3:22 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> [+cc Rafael, just FYI since it involves PNP resources]
>>
>> On Wed, Mar 27, 2013 at 10:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> Mathhew reported kernels fail the pci_eisa probe and are later successful
>>> with the virtual_eisa_root_init force probe without slot0.
>>>
>>> The reason for that is: pnp probing is early than pci_eisa_init get called
>>> as pci_eisa_init is called via pci_driver.
>>>
>>> pnp 00:0f has 0xc80 - 0xc84 reserved.
>>> [    9.700409] pnp 00:0f: [io  0x0c80-0x0c84]
>>>
>>> so eisa_probe will fail from pci_eisa_init
>>>                                 ==>eisa_root_register
>>>                                         ==>eisa_probe path.
>>> as force_probe is not set in pci_eisa_root, it will bail early when
>>> slot0 is not probed and initialized.
>>>
>>> Try to use subsys_initcall_sync instead, and will keep following sequence:
>>>         pci_subsys_init
>>>         pci_eisa_init_early
>>>         pnpacpi_init/isapnp_init
>>
>> Is this a regression?  This must have worked at one time, but it seems
>> like we've had pnpacpi_init/isapnp_init/pnpbios_init before PCI
>> drivers for quite a while.
>
> Yes.

Do you know when the regression occurred?  If you do, I'll add that
info to the "stable" tag.

Bjorn
