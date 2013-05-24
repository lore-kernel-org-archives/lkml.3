Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab3EXRFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:05:47 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:37138 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab3EXRFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:05:46 -0400
X-Auth-Info: G7rAS9E/BYhFsGHBi6dL382EIHFlsrvmf1QcVNqrMOI=
Date: Fri, 24 May 2013 19:05:44 +0200
From: Anatolij Gustschin <agust@denx.de>
To: "Thumshirn, Johannes Tobias" <Johannes.Thumshirn@men.de>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Freescale P1022 SoC hangs when initializing USB
Message-ID: <20130524190544.0851d94f@crub>
In-Reply-To: <42A09AAC7DAAF64ABE4E4C1AD5F5E295094C5B5F@MEN-EX1.intra.men.de>
References: <42A09AAC7DAAF64ABE4E4C1AD5F5E295094C5B5F@MEN-EX1.intra.men.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013 14:42:46 +0000
"Thumshirn, Johannes Tobias" <Johannes.Thumshirn@men.de> wrote:

> Hi list,
> 
> I'm experiencing problems while booting on a Freescale P1013 based board. It hangs on USB initialization:
> [    3.763584] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    3.770519] ehci-pci: EHCI PCI platform driver
> [    3.775116] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    3.781972] fsl-ehci fsl-ehci.0: Freescale On-Chip EHCI Host Controller
> [    3.788812] fsl-ehci fsl-ehci.0: new USB bus registered, assigned bus number 1
> 
> The corresponding device-tree:
> usb@22000 {
>                      #address-cells = <1>;
>                      #size-cells = <0>;
>                      compatible = "fsl-usb2-dr";
>                      reg = <0x22000 0x1000>;
>                      interrupt-parent = <&mpic>;
>                      interrupts = <28 0x2 0 0>;
>                      phy_type = "ulpi";
> };
> 
> usb@23000 {
>                       #address-cells = <1>;
>                       #size-cells = <0>;
>                       compatible = "fsl-usb2-dr";
>                       reg = <0x23000 0x1000>;
>                       interrupt-parent = <&mpic>;
>                       interrupts = <46 0x2 0 0>;
>                       phy_type = "ulpi";
> };

please change compatible property in both nodes to

 compatible = "fsl-usb2-dr-v1.6", "fsl-usb2-dr";

and try again to see if it helps.

Thanks,

Anatolij
