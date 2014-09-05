Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaIETB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:01:29 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53200 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaIETBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:01:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: keystone: update to support multiple pci ports
Date: Fri, 05 Sep 2014 21:00:19 +0200
Message-ID: <3654923.JrIGV2dJ70@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540A0212.6060303@ti.com>
References: <1409938782-31460-1-git-send-email-m-karicheri2@ti.com> <7260053.FoBVhTXVfj@wuerfel> <540A0212.6060303@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0c5CXRbB4UqVWdpsr7dWprTeRsDw9zcm+VOTa8b9+dx
 Bf96srJF6c5l2eke0znpsi/W/p2Jc3rEWod/rL/DJuUAYatZmn
 +2uX0uF/dEHHFq0cd2zLH3eMydBAeGpV4nL24GCPBLKEDvU5E/
 QaTVbhaXGKyKJFWIh/qMhnR3cCo4q17W1QT2LejrAd8d7ZkpiD
 PQDA8Yr/eWOLwMmB0XA1BT4I/mS0tQvXcwHFDlfeOLgJQrICKN
 hFqnFOX+E8uu1pN/8aTx8/le8vQVqZS0/sEnIe85UL8lXfXwyp
 jE3ZnUhHcPEfp46BZVkWGt0DqZH2kXRy4/frNN/IBW87tOc51H
 qDiqjxmjsSTEitMTtTF8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 14:33:54 Murali Karicheri wrote:
> > This looks like it's a shared register of some sort that doesn't
> > really belong into the registers of a particular port. Could it
> > be that it's actually for the PHY?
> >
> This a shared device configuration register between the two ports the 
> desciption states it is bootstrap configuration of the PCIe module as 
> Endpoint or Root complex and Not Phy. Hope below text will help.

Ok. Why do you want to have this user-selectable though? Can't it
just be set by the boot loader before starting Linux?

	Arnd

> Table 3-23 Device Configuration Register (DEVCFG)
> 
> 
> PCIESSMODE[1:0] 00b PCIESSMODE is used to control the
> functionality of PCIESS module out of
> reset. This MMR output is connected to
> DEVTYPE input of PCIESS
> (Changes from
> Nysh) : Note that in Nysh this value came
> from a bootstrap pin.
> 00 : Endpoint
> 01 : Legacy Endpoint
> 10 : Rootcomplex
> 11 : Reserved
> PCIESS_1_MODE[1:0
> ]
> 00b PCIESSMODE is used to control the
> functionality of PCIE_1 module out of
> reset. This MMR output is connected to
> DEVTYPE input of PCIE_1
> 00 : Endpoint
> 01 : Legacy Endpoint
> 10 : Rootcomplex
> 11 : Reserv
> 

