Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaIEVMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:12:31 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:55920 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaIEVMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:12:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: keystone: update to support multiple pci ports
Date: Fri, 05 Sep 2014 23:11:47 +0200
Message-ID: <5769746.NkKjYOOUiv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540A1F05.80706@ti.com>
References: <1409938782-31460-1-git-send-email-m-karicheri2@ti.com> <3654923.JrIGV2dJ70@wuerfel> <540A1F05.80706@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QijqIZ23EaS08FZS8CFNWpZzPCbixK0y4m4st15dBiG
 qGevmm0uYCxtsYrlOEFqilXUJyqyEyvh6ahjqD1czcgZL53QFY
 NYUsaEpMh4jn/w5HNTHUd5GMdXEsupfuH++oL8rppVFZRQ88sJ
 GQzHxBAKUCwc4P/srZUUGHrqeqjTLdNsG27mP4BsqNdije1kY5
 n0g0dMP5hYjhmDIWzK9DfDIg5VskZqRUUwNND3ux9mcjQcRA+L
 dERkbVQFggjiZOPI2tv4gCKDuAeJfe0Zyyketp0+jeDIB6/alz
 Ao3hujeBvsbACOxitqhQ1gfa7gkLOqUBtUeV0H5YDyMRXurfbY
 Dky072yy9+wX/o1XRwi4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 16:37:25 Murali Karicheri wrote:
> On 09/05/2014 03:00 PM, Arnd Bergmann wrote:
> > On Friday 05 September 2014 14:33:54 Murali Karicheri wrote:
> >>> This looks like it's a shared register of some sort that doesn't
> >>> really belong into the registers of a particular port. Could it
> >>> be that it's actually for the PHY?
> >>>
> >> This a shared device configuration register between the two ports the
> >> desciption states it is bootstrap configuration of the PCIe module as
> >> Endpoint or Root complex and Not Phy. Hope below text will help.
> >
> > Ok. Why do you want to have this user-selectable though? Can't it
> > just be set by the boot loader before starting Linux?
> 
> Arnd,
> 
> As the driver is responsible for configuring the device to support the 
> device functionality, it make sense to do this in the device driver. The 
> driver enables clock to the IP and this is an addition thing to be 
> configured so that when the device is powered up, it should function as 
> RC. The IP can be configured to work as Root Complex or Endpoint. So not 
> sure why you want to me to move this functionality to boot loader.

But the driver can only do root complex mode, and we would probably
want a completely different driver if we were to start supporting
endpoint mode.

This also implies that the firmware has to pass a different DT for
endpoint mode, so it should be responsible for setting up the hardware
to match the DT.

	Arnd
