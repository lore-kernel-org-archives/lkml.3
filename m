Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3CJDer (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 22:34:47 -0500
Received: from plane.gmane.org ([80.91.229.3]:38215 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab3CJDeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 22:34:46 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marco <scamar@gmail.com>
Subject: Re: xhci module fails when booting in UEFI mode
Date: Sun, 10 Mar 2013 03:26:35 +0000 (UTC)
Message-ID: <loom.20130310T042356-814@post.gmane.org>
References: <kcm7tc$aom$1@ger.gmane.org> <20130216173350.GA4821@hardeman.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 2.227.133.46 (Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Härdeman <david <at> hardeman.nu> writes:

> 
> On Thu, Jan 10, 2013 at 11:15:56AM +0000, Frederik Himpe wrote:
> >I've got a HP EliteBook 8470p on which I installed Debian Wheezy in UEFI 
> >mode. With both the 3.2 kernel from Wheezy, as the 3.7.1 kernel from 
> >experimental, xhci fails to initialize and my USB mouse connected to one 
> >of these ports is not recognized at all. The USB3 ports work fine in 
> >Windows.
> >
> >[    1.316248] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
> >[    1.316251] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
> >[    1.316253] 
> >[    1.316277] xhci_hcd 0000:00:14.0: setting latency timer to 64
> >[    1.316281] xhci_hcd 0000:00:14.0: xHCI Host Controller
> >[    1.316287] xhci_hcd 0000:00:14.0: new USB bus registered, assigned 
> >bus number 1
> >[    1.316393] xhci_hcd 0000:00:14.0: cache line size of 64 is not 
> >supported
> >[    1.316395] xhci_hcd 0000:00:14.0: request interrupt 255 failed
> >[    1.316447] xhci_hcd 0000:00:14.0: USB bus 1 deregistered
> >[    1.316466] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
> >[    1.316467] xhci_hcd 0000:00:14.0: init 0000:00:14.0 fail, -22
> >[    1.316505] xhci_hcd: probe of 0000:00:14.0 failed with error -22
> >
> >Full dmesg, lspci, lsusb and lsmod can be found here:
> >http://artipc10.vub.ac.be/~frederik/uefi-xhci/
> >
> >I found this report about the same problem on a HP Probook system: 
> >https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1072918 
> 
> I have the same problem (HP Elitebook 8570p in my case).
> 
> This thread seems related:
> https://lkml.org/lkml/2012/2/13/453
> 
> No idea what happened to the patches in that thread though...
> 


workaround on hp 8570


using kernel parameter

acpi=noirq

USB 3 will work

........
[ 0.000000] Linux version 3.5.0-25-generic (buildd@komainu) (gcc version 4.7.2
(Ubuntu/Linaro 4.7.2-2ubuntu1) ) #39-Ubuntu SMP Mon Feb 25 18:26:58 UTC 2013
(Ubuntu 3.5.0-25.39-generic 3.5.7.4)
[ 0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.5.0-25-generic.efi.signed
root=UUID=f8ccd8b4-9642-48c1-b57d-258ebbb6ee14 ro quiet splash acpi=noirq
vt.handoff=7
........
$ dmesg | grep xhci
[ 1.141906] xhci_hcd 0000:00:14.0: can't find IRQ for PCI INT A; please try
using pci=biosirq
[ 1.141922] xhci_hcd 0000:00:14.0: setting latency timer to 64
[ 1.141924] xhci_hcd 0000:00:14.0: xHCI Host Controller
[ 1.141927] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[ 1.142008] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[ 1.142048] xhci_hcd 0000:00:14.0: irq 23 for MSI/MSI-X
[ 1.142087] usb usb3: Manufacturer: Linux 3.5.0-25-generic xhci_hcd
[ 1.142137] xHCI xhci_add_endpoint called for root hub
[ 1.142139] xHCI xhci_check_bandwidth called for root hub
[ 1.142196] xhci_hcd 0000:00:14.0: xHCI Host Controller
[ 1.142198] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[ 1.142218] usb usb4: Manufacturer: Linux 3.5.0-25-generic xhci_hcd
[ 1.142260] xHCI xhci_add_endpoint called for root hub
[ 1.142261] xHCI xhci_check_bandwidth called for root hub
[ 15.089213] genirq: Flags mismatch irq 23. 00002001 (lis3lv02d) vs. 00000000
(xhci_hcd)
........

if you like to recompile your own kernel, someone has reported this patch work
i can wait until this one will be included in the main kernel :D

https://lkml.org/lkml/2013/2/18/115




