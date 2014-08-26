Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaHZPiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:38:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43038 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751441AbaHZPiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:38:54 -0400
Date: Tue, 26 Aug 2014 11:38:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Gavin Guo <gavin.guo@canonical.com>
cc: linux-usb@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>, YK <yk@canonical.com>
Subject: Re: About the reboot hang issue with EHCI driver on the Baytrail
 platform
In-Reply-To: <CA+eFSM3VvSKQ51+9bn0CADOMR9AUU0Xc-viFgHhcniHNN=mNKg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1408261134290.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Gavin Guo wrote:

> Hi,
> 
> I found that in the Baytrail-m platform if the "USB3.0 Configuration
> in Pre-OS" is set to Auto in the BIOS, the system will boot with
> EHCI-enabled. And test reboot 200 times. It sometimes hang in the
> shutdown process "ehci-pci 0000:00:1d.0: shutdown." I also found that
> sometimes hang in the booting up process. But it still black screen, I
> can't see clearly where it hang.
> 
> After doing some experiments, I found the following symptoms:
> 1) Set the "USB3.0 Configuration in Pre-OS" to enable, the 200 times
> reboot test can pass. Under the condition, lspci can't see the EHCI
> [8086:0f34] controller.
> 
> 2) Build a new kernel without the EHCI driver can also pass the 200
> times reboot test.
> 
> 3) Put "echo -n "0000:00:1d.0" > /sys/bus/pci/drivers/ehci-pci/unbind"
> in the /etc/rc.local can avoid shutdown hang but sometimes it also
> hang in the booting up process during the 200 times reboot test.
> 
> 4) I also found some messages in dmesg which show "ehci-pci
> 0000:00:1d.0: port 1 reset error -110."

It sounds like the BIOS is buggy.

> If there is any possibility to disable the EHCI controller in the
> Baytrail platform because the XHCI covers all the ports connected to
> EHCI controller.

You can disable the EHCI controller by setting "USB3.0 Configuration in 
Pre-OS" to enable, as you discovered.

>  And IIRC, there is only one host controller within
> EHCI and XHCI can be enabled in the Baytrail platform. I'm also trying
> to find out the kernel parameters to disable the EHCI driver, but
> currently there is no available one.

It's not a kernel parameter.  You can blacklist the ehci-pci and 
ehci-hcd modules in /etc/modprobe.d/local.conf.

Or you can turn off CONFIG_USB_EHCI_HCD in your .config and build a 
kernel with no EHCI support at all.

Alan Stern

