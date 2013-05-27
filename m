Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3E0IyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:54:18 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.176]:43011 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201Ab3E0IyN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:54:13 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 May 2013 04:54:13 EDT
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-3.tower-38.messagelabs.com!1369644478!15746862!1
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 27 May 2013 10:47:58 +0200
From: "Thumshirn, Johannes Tobias" <Johannes.Thumshirn@men.de>
To: Anatolij Gustschin <agust@denx.de>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: Freescale P1022 SoC hangs when initializing USB
Thread-Topic: Freescale P1022 SoC hangs when initializing USB
Thread-Index: Ac5Yiav6I+2AGvzgSC60Xd9zUMXBtAABn3QAAImgtiA=
Date: Mon, 27 May 2013 08:47:55 +0000
Message-ID: <42A09AAC7DAAF64ABE4E4C1AD5F5E295094C82C9@MEN-EX1.intra.men.de>
References: <42A09AAC7DAAF64ABE4E4C1AD5F5E295094C5B5F@MEN-EX1.intra.men.de>
 <20130524190544.0851d94f@crub>
In-Reply-To: <20130524190544.0851d94f@crub>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.6.58]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 27 May 2013 08:47:58.0064 (UTC) FILETIME=[E3147700:01CE5AB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
>                      phy_type = "ulpi"; };
> 
> usb@23000 {
>                       #address-cells = <1>;
>                       #size-cells = <0>;
>                       compatible = "fsl-usb2-dr";
>                       reg = <0x23000 0x1000>;
>                       interrupt-parent = <&mpic>;
>                       interrupts = <46 0x2 0 0>;
>                       phy_type = "ulpi"; };

please change compatible property in both nodes to

 compatible = "fsl-usb2-dr-v1.6", "fsl-usb2-dr";

and try again to see if it helps.

Thanks,

Anatolij

This solves the boot hang, thanks a lot

Johannes
