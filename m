Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529AbaKNOwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:52:40 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:54731 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965341AbaKNOwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:52:38 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2014 09:52:38 EST
Date: Fri, 14 Nov 2014 15:42:52 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Peter Jones <pjones@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, ia64: Do not lose track of the EFI default VGA
 device
Message-ID: <20141114154252.0fb66bba@pluto.restena.lu>
In-Reply-To: <1415969610-1469-1-git-send-email-rydberg@euromail.se>
References: <1415969610-1469-1-git-send-email-rydberg@euromail.se>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 13:53:30 +0100 Henrik Rydberg wrote:
> Since commit 20cde694027e ("x86, ia64: Move EFI_FB
> vga_default_device() initialization to pci_vga_fixup()") in the 3.17
> merge window, the EFI framebuffer depends on the VGA arbitration
> layer. However, the configuration does not reflect this, which leads
> to a hard-to-find bug when FB_EFI is configured without VGA_ARB. Add a
> select clause to remedy this.

Could you be more verbose in why it depends on/needs VGA_ARB?

With EFI starting to show up on ARM this is not necessarily true
(no PCI -> no VGA_ARB arbitration).


So it would need to at least be select VGA_ARB if (PCI && !S390)
in order to not have broken kernel configuration (in more or less
exotic cases) while depends on VGA_ARB would be the only correct option
if the rule 'select only allowed for leafs' is enforced.

Bruno

> Cc: Bruno Prémont <bonbons@linux-vserver.org>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Peter,
> 
> I stumbled upon this bug from the 3.17 merge window when updating to
> Linus's 3.18 git head yesterday. The patch has been tested on two
> different EFI machines; one that needs the patch and one that does not.
> 
> Thanks,
> Henrik
> 
>  drivers/video/fbdev/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
> index c7bf606..81b21bc 100644
> --- a/drivers/video/fbdev/Kconfig
> +++ b/drivers/video/fbdev/Kconfig
> @@ -761,6 +761,7 @@ config FB_EFI
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
> +	select VGA_ARB
>  	help
>  	  This is the EFI frame buffer device driver. If the firmware on
>  	  your platform is EFI 1.10 or UEFI 2.0, select Y to add support for
