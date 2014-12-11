Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967504AbaLKXAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:00:09 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:39070 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967198AbaLKXAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:00:06 -0500
Date: Thu, 11 Dec 2014 22:57:18 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dely Sy <dely.l.sy@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Praveen Kalamegham <praveen@nextio.com>
Subject: Re: Special handling of display/VGA devices in hotplug drivers
Message-ID: <20141211225718.403ada7e@lxorguk.ukuu.org.uk>
In-Reply-To: <CAErSpo4V8tYE+yHvQ+Se=tQHWAKafk89SmVTjeCVRzbA-VtQbg@mail.gmail.com>
References: <CAErSpo4iZCUZgqNi-fX+YX=sKV=Ae5z8kn8-++E0Cgft9unmBg@mail.gmail.com>
	<20141211181136.GA11367@kroah.com>
	<20141211113243.3f21551e@jbarnes-t420>
	<CAErSpo4V8tYE+yHvQ+Se=tQHWAKafk89SmVTjeCVRzbA-VtQbg@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> The PCI spec said that you were not allowed to hotplug VGA drivers.
> >> The big issue is that POST usually needs to run on those things, and
> >> there is no way to POST a PCI hotplugged device.
> 
> I don't think this is a problem any more, is it?  I think X can
> execute option ROMs, and if we assign the guest to a VM, the guest
> BIOS can also do it.

Providing the legacy I/O is routed to that device, it doesn't use DMA and
a few other things. X has been able to POST cards with vm86 or the 8086
emulator stuff for a long time (it had to in order to use most PC cards on
non x86 boxes).

Your bigger problem is the marvellous reliable way that X handles a GPU
simply vanishing, especially a legacy one.

Alan
