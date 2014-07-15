Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaGOP6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:58:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49779 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751857AbaGOP6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:58:47 -0400
Date: Tue, 15 Jul 2014 11:58:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <Peter.Chen@freescale.com>,
        <kishon@ti.com>, <sergei.shtylyov@cogentembedded.com>,
        <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] usb: add support for the generic PHY framework
In-Reply-To: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
Message-ID: <Pine.LNX.4.44L0.1407151157380.1206-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Antoine Ténart wrote:

> Hi all,
> 
> This is an attempt to add more common USB code aware of the generic PHY
> framework, while keeping the compatibility for the USB PHY one. It does
> not add the full support, some USB PHY specific functions not being
> available currently in the generic PHY subsystem (e.g. usb_phy_set_power()).
> But it allows to use the generic PHY framework in other cases, and might
> help others to convert their USB PHY drivers.
> 
> A little background: I submitted a series to support USB on Berlin SoCs[1].
> One patch added a new PHY driver in drivers/usb/phy and Felipe asked it to
> be in the generic PHY framework instead[2]. This PHY being used by a ChipIdea
> driver, changes were needed in ChipIdea, OTG and HCD.
> 
> This is done in 3 steps:
>         1. moving the OTG state from the USB PHY structure to the OTG one
>         2. renaming the field 'phy' to 'usb_phy'
>         3. adding a field for the generic framework PHY and dissociating its
>            use from the USB PHY one
> 
> Step 1 is in the first patch. Steps 2 and 3 are done for OTG, and ChipIdea
> subsystems in patches 2-3 and 7-8.
> 
> HCD generic PHY support was made by Sergei and Yoshihiro[1]. I added some
> modifications to make this support consistent with this series in patches
> 4-6.
> 
> I tested it by using the ChipIdea driver I introduced, both with an USB PHY
> and a PHY driver successfully. I also compiled a multi_v7 kernel (ARM), with
> every driver I could enable in the USB section.
> 
> I'd like more people to test and your inputs and suggestions on these changes.
> 
> Feel free to add Ccs if others might be interested in this. If needed patches
> can be squashed or divided, I tried there to group modifications by USB
> framework parts (OTG, HCD, ChipIdea).
> 
> Patches can also be found at:
> git://git.free-electrons.com:users/antoine-tenart/linux.git usb-phy
> 
> The series applies on top of Sergei and Yoshihiro generic PHY support in
> HCD[1].

For the changes to hub.c, hcd.c, and the ehci and ohci drivers:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

