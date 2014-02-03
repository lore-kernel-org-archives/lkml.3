Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaBCOwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:52:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49352 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaBCOwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:52:23 -0500
Date: Mon, 3 Feb 2014 09:52:05 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Eiichiro Oiwa <eiichiro.oiwa.nm@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        "linux-pci @ vger . kernel . org" <linux-pci@vger.kernel.org>,
        linux-ia64@vger.kernel.org
Subject: Re: [PATCH v2] Setting the IORESOURCE_ROM_SHADOW flag on a VGA card
 other than the primary prevents it from reading it's own rom. It will get
 the content of the shadowrom at C000 instead, which is of the primary VGA
 card and the driver of the secondary card will bail out.
Message-ID: <20140203145205.GB2992@phenom.dumpdata.com>
References: <20140130000831.GJ16825@google.com>
 <1391160503-11122-1-git-send-email-linux@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391160503-11122-1-git-send-email-linux@eikelenboom.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 10:28:22AM +0100, Sander Eikelenboom wrote:
> Hi Bjorn / Tony,
> 
> I fixed up ia64 as well and brought it inline again with the x86 code,
> but i don't have a ia64 machine, so that part is untested.
> Perhaps Tony is able to review/test it ?
> 
> Sander
> 
> 
> 
> Setting the IORESOURCE_ROM_SHADOW flag on a VGA card other than the primary
> prevents it from reading it's own rom. It will get the content of the shadowrom
> at C000 instead, which is of the primary VGA card and the driver of the
> secondary card will bail out.
> 
> Fix this by checking if the arch code or vga-arbitration has already
> determined the vga_default_device, if so only apply the fix to this
> primary video device and let the comment reflect this.
> 
> v2:
>     - Fix pci_fixup_video both in x86 and ia64
> 
> 
> Sander Eikelenboom (1):
>   Setting the IORESOURCE_ROM_SHADOW flag on a VGA card other than the
>     primary     prevents it from reading it's own rom. It will get the
>     content of the shadowrom     at C000 instead, which is of the
>     primary VGA card and the driver of the     secondary card will bail
>     out.

Your editor mutilated your subject line. It ought to have been just
one line.

Anyhow, you can also add 'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com'
on the patch for the x86 part.

The ia64 "looks" OK to me, but my ia64 box won't boot v3.11 or later
so I can't give it a 'Tested-by' yet.

> 
>  arch/ia64/pci/fixup.c |   24 +++++++++++++-----------
>  arch/x86/pci/fixup.c  |   18 ++++++++++--------
>  2 files changed, 23 insertions(+), 19 deletions(-)
> 
> -- 
> 1.7.10.4
> 
