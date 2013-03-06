Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3CFQSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:18:24 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:35627 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab3CFQSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:18:22 -0500
MIME-Version: 1.0
In-Reply-To: <1362585587.2140.8.camel@localhost>
References: <1362585587.2140.8.camel@localhost>
Date: Wed, 6 Mar 2013 11:18:21 -0500
Message-ID: <CA+5PVA7n13iH3o3KmjOc5RfkSgKQGJdCah9qP+rJGmEDXgMROA@mail.gmail.com>
Subject: Re: [REGRESSION] 3.9-rc1 kernel usb root hub stops working and cannot reboot
From: Josh Boyer <jwboyer@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 10:59 AM, Eric Paris <eparis@redhat.com> wrote:
> I've got a Lenovo T530.  Booting a 3.8 based Fedora kernel my machine
> works just fine.  Booting a 3.9-rc1 based Fedora kernel my USB 2.0 root
> hub doesn't seem to notice when devices are plugged in.  (The USB 3.0
> root hub has no such problem)  I'm assuming (maybe stupidly) it is
> associated with:
>
> Mar 06 09:52:35 localhost kernel: pci 0000:00:1c.0: can't find IRQ for PCI INT A; please try using pci=biosirq
> Mar 06 09:52:35 localhost kernel: pci 0000:00:1c.1: can't find IRQ for PCI INT B; please try using pci=biosirq
> Mar 06 09:52:35 localhost kernel: pci 0000:00:1c.2: can't find IRQ for PCI INT C; please try using pci=biosirq
>
> (also, funny thing, pci=biosirq is not a valid command line option, glad
> it told me to try that)
>
> I also notice that the 3.9 kernels cannot reboot.  The kernel output the
> machine restart message and then just hangs forever.  Again, this works
> just fine on the 3.8 kernels.

You're booting via EFI, right?  I'm debugging an identical issue on an
EFI machine here.  Basically, it looks like the efi_info variable in the
bootparams thing is cleared so EFI/ACPI is all broken.

There's a suspect commit but I'm still bisecting so I won't be blaming
anything yet.  If you'd like to follow along in Fedora land, I'm working
with bug 918408.

josh
