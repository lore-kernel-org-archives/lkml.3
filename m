Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab3HTXJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:09:07 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60974 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3HTXJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:09:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5AiRw7HvGQMq-n596ZkHJs_KJNn346yf+jc7yti-xpUw@mail.gmail.com>
References: <CAErSpo53L3-feEw0qZvBTmRrY+SXpGrGU6oxZg3wVjH1M8JDXg@mail.gmail.com>
 <F6FB0E698C9B3143BDF729DF222866466FD41225@ORSMSX110.amr.corp.intel.com> <CAErSpo5AiRw7HvGQMq-n596ZkHJs_KJNn346yf+jc7yti-xpUw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 20 Aug 2013 17:08:43 -0600
Message-ID: <CAErSpo4E9LNrfqTq1_WUoAx68_krw23BjSYbPpJPOr=zbq98xA@mail.gmail.com>
Subject: Re: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type 00
 to PF Nacked" messages
To: "Skidmore, Donald C" <donald.c.skidmore@intel.com>
Cc: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Don Dutile]

On Tue, Aug 13, 2013 at 8:23 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Aug 13, 2013 at 3:54 PM, Skidmore, Donald C
> <donald.c.skidmore@intel.com> wrote:
>
>> We were unable to recreate your failure here locally so I have some additional questions.  First off you mentioned it was failing as far back as v3.9, was it ever working for you?  If so bisecting would be really helpful as I mentioned we have been unable to cause the failure in house.
>
> I'm not aware of any working version.  I'm exercising in the sysfs
> SR-IOV configuration, which I think appeared in v3.8 or so.
>
>>  If not could you see if the problem still occurs without the external Magma PCIe expansion chassis, this is of course assuming that you can plug the X540 into your system without it.
>
> I played with this a little more and found this:
>
> 1) Magma card in z420, connected to chassis containing X540: fails
> (original report)
> 2) X540 in z420, Magma card in z420, connected to empty chassis: fails
> 3) X540 in z420, Magma card in z420 but no cable to chassis: works
>
> The only difference I've noticed so far between configs 2 & 3 are
> different bus numbers and different IRQ assignments:
>
> Config 2 (failing):
>   pci 0000:0c:00.0: [8086:1528] type 00 class 0x020000
>   pci 0000:0c:00.0: reg 0x10: [mem 0xdac00000-0xdadfffff 64bit pref]
>   ixgbe 0000:0c:00.0: irq 82 for MSI/MSI-X
>   IRQ 79: 79
>   IRQ 80: eth0
>   IRQ 81: snd_hda_intel
>   IRQ: 82-93 eth1-TxRx-0 through eth1-TxRx-11
>   IRQ 94: eth1
>
> Config 3 (working):
>   pci 0000:04:00.0: [8086:1528] type 00 class 0x020000
>   pci 0000:04:00.0: reg 0x10: [mem 0xdac00000-0xdadfffff 64bit pref]
>   ixgbe 0000:04:00.0: irq 75 for MSI/MSI-X
>   IRQ 72: ahci
>   IRQ 73: eth0
>   IRQ 74: snd_hda_intel
>   IRQ 75-86: eth1-TxRx-0 through eth1-TxRx-11
>   IRQ 87: eth1
>
> I'll try to narrow this down a little more; I'm just giving you this
> preliminary info in case it rings any bells for you.

Sorry, I haven't gotten anywhere with this yet.  I opened
https://bugzilla.kernel.org/show_bug.cgi?id=60776 and attached logs
and lspci info from v3.11-rc6.

Bjorn
