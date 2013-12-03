Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab3LCBYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 20:24:31 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:35970 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3LCBY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 20:24:27 -0500
MIME-Version: 1.0
In-Reply-To: <20131129175336.GA6152@kroah.com>
References: <20131129031419.GB5889@neilslaptop.think-freely.org>
 <20131129094137.GC3028@redhat.com> <20131129175336.GA6152@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 2 Dec 2013 18:24:06 -0700
Message-ID: <CAErSpo44sQU2PbufCYF+wzpMtMPC97_FgAMQgruX9Nw3XbmL8g@mail.gmail.com>
Subject: Re: [PATCH] PCI: export MSI mode using attributes, not kobjects
To: Greg KH <greg@kroah.com>
Cc: Veaceslav Falico <vfalico@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 10:53 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Nov 29, 2013 at 10:41:37AM +0100, Veaceslav Falico wrote:
>> On Wed, Nov 27, 2013 at 10:46:52AM -0800, Greg Kroah-Hartman wrote:
>> >From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >
>> >The PCI MSI sysfs code is a mess with kobjects for things that don't
>> >really need to be kobjects.  This patch creates attributes dynamically
>> >for the MSI interrupts instead of using kobjects.
>> >
>> >Note, this removes a directory from the current MSI interrupt sysfs
>> >code:
>> >
>> >old MSI kobjects:
>> >pci_device
>> >   └── msi_irqs
>> >       └── 40
>> >           └── mode
>> >
>> >new MSI attributes:
>> >pci_device
>> >   └── msi_irqs
>> >       └── 40
>> >
>> >As there was only one file "mode" with the kobject model, the interrupt
>> >number is now a file that returns the "mode" of the interrupt (msi vs.
>> >msix).
>> >
>> >Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> Works like a charm for me.
>>
>> FWIW,
>>
>> Reviewed-by: Veaceslav Falico <vfalico@redhat.com>
>
> On Thu, Nov 28, 2013 at 10:14:19PM -0500, Neil Horman wrote:
>> ACK, Testing with git-head irqbalance on F19 with this patch and it works fine.
>>
>> Thanks!
>> Acked-by: Neil Horman <nhorman@tuxdriver.com>
>
> Great, thanks for both of you testing this.
>
> Bjorn, any objection to take this through your tree for 3.14-rc1?

Nope, I don't object at all.  We probably should update
Documentation/ABI/testing/sysfs-bus-pci at the same time, though.

Bjorn
