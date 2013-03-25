Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab3CYJaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:30:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62655 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab3CYJaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:30:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [RFC 0/2] PCI: Introduce MSI chip infrastructure
Date: Mon, 25 Mar 2013 09:29:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de> <20130325093847.7474dc0e@skate> <20130325091534.GA21054@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130325091534.GA21054@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303250929.58010.arnd@arndb.de>
X-Provags-ID: V02:K0:WlR5BkbEPLmWbsp/LaySYMLpAdfDVV0z4BYeQSEmBQd
 LYuefDDTPAVfWf//4vUDvX+YNSzBSgMwXPv2LerUM917j/ZWdL
 xH4K7NNizR5ZThECZ7myM3Sg40QbhJ51WtyOKOHn/7Q8l0QBP4
 Fxh3mt8cMhhev1tNkiVCT3z5Z+UE17HnpbKZidpNYXFmpgcqDv
 9ZXbsp8cvQOzaKNFonq4TppPgmrKZ1ukkPB1znS8/o0LvSQUkB
 EFZchUxvKdUsgLofelTaWAhYXlhiO+J2K+fS/o34riELBAgXlx
 rOUW17HqGp7f6xMotdGCBk36n7zOw3HHUF/ios7V6Q3oAhUE7X
 2PVK4GeGIpyD2IBiqZOM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, Thierry Reding wrote:
> I think you can just make this:
> 
>         mpic: interrupt-controller@d0020000 {
>                 ...
>         };
> 
>         ...
> 
>         soc {
>                 pcie-controller {
>                         marvell,msi = <&mpic>;
>                 };
>         };
> 
> And everything else should just work given the APIs I mentioned. But as
> you said it'd be good if somebody else could share their opinion about
> this.


I think the property referring to the msi controller should have a fixed
name, such as "msi-parent", to go along with "interrupt-parent".
Similarly, I would suggest using an empty "msi-controller" property
to mark the controller that is capable of serving MSIs. The Linux
implementation doesn't currently require the "interrupt-controller"
property, but I think it's good to stay close to the original interrupt
binding here for consistency.

	Arnd
