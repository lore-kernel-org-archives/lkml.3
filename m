Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3ISL2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:28:36 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45079 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3ISL2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:28:34 -0400
MIME-Version: 1.0
Date: Thu, 19 Sep 2013 16:58:34 +0530
X-Google-Sender-Auth: 8zF98V5p8WS2cRUzlrnZ6EPNGHQ
Message-ID: <CAPV97ye73kaP3+8MNRq=C7=SdsrDOXRHJQDhw0E0p=pLgPjgBg@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: Fix build on Debian ppc
From: navin patidar <navinp@cdac.in>
To: Dominik Paulus <dominik@d-paulus.de>
Cc: Tobias Polzer <bulsa.t.polzer@studium.uni-erlangen.de>,
        Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        usbip-devel@lists.sourceforge.net,
        Tobias Polzer <tobias.polzer@fau.de>, linux-kernel@vger.kernel.org,
        Dominik Paulus <dominik.paulus@fau.de>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On September 19, 2013 at 3:40 PM Dominik Paulus <dominik@d-paulus.de> wrote:
> On Thu, Sep 19, 2013 at 12:12:44PM +0300, Dan Carpenter wrote:
> > On Thu, Sep 19, 2013 at 10:55:18AM +0200, Tobias Polzer wrote:
> > > When testing usbip under powerpc, it (unexpectedly) worked, but only after
> > > removing the following lines from vhch_hcd.c:
> > >
> > > 1004 /* will be removed */
> > > 1005 if (pdev->dev.dma_mask) {
> > > 1006 dev_info(&pdev->dev, "vhci_hcd DMA not supported\n");
> > > 1007 return -EINVAL;
> > > 1008 }
> > >
> > > We encountered no problems without those lines. Is it safe to remove this
> > > check?
> >
> > Hehe. No.
> >
> > Also which vhch_hcd.c are you talking about? "find -name vhch_hcd.c"
> > doesn't show anything.
>
> Sorry for the typo, we meant vhci_hcd.c in
> drivers/staging/usbip/vhci_hcd.c.
>
> > What the error message?
>
> When modprobing vhci_hcd.ko, vhci_hcd_probe() fails and returns -EINVAL,
> resulting in this error message:
>
> [ 592.623292] vhci_hcd vhci_hcd: vhci_hcd DMA not supported
> [ 592.624031] vhci_hcd: probe of vhci_hcd failed with error -22
>
> This leads to the virtual host controller device (vhci) not being
> created, so usbip cannot work.
> It works after removing the codeblock mentioned above.
>
> We did some research and discovered that dma_mask is only set on PowerPC
> at the moment (in arch/powerpc/kernel/setup-common.c,
> arch_setup_pdev_archdata()).
>
> All of our testing was done in QEMU emulating Debian on POWER7.
>

I have already submitted a patch to remove mentioned code block.
patch link : https://lkml.org/lkml/2013/9/10/26


regards,
--navin-patidar
