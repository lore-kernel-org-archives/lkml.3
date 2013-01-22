Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab3AVW7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:59:40 -0500
Received: from mout.gmx.net ([212.227.17.20]:54476 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab3AVW7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:59:38 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19RcU1VTMpRYQQ2rI/BotL0mEnS9hBDhaM4k2nrS/
	ACfG6UVItKrPgO
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] staging/comedi: Use comedi_pci_auto_unconfig directly for pci_driver.remove
Date: Wed, 23 Jan 2013 00:02:48 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.4; KDE/4.9.3; x86_64; ; )
Cc: Ian Abbott <abbotti@mev.co.uk>, Mori Hess <fmhess@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1358894403-26181-1-git-send-email-peterhuewe@gmx.de> <ADE657CA350FB648AAC2C43247A983F00207A6F697BB@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00207A6F697BB@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301230002.48551.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 22. Januar 2013, 23:49:53 schrieb H Hartley Sweeten:
> On Tuesday, January 22, 2013 3:40 PM, Peter Huewe wrote:
> >  (Almost) all comedi pci drivers have some wrapper for their
> > 
> > pci_driver.remove function which simply calls comedi_pci_auto_unconfig
> > which has the same function prototype as the wrapper.
> > 
> > -> we can remove these wrappers and call comedi_pci_auto_unconfig
> > directly. This removes a lot some boilerplate code and saves some bytes.
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > ---
> > Maybe we should move the implementation now to drivers.c,
> > because now it cannot be inlined anymore.
> > This would save some more bytes in the .kos but comedi_pci_auto_unconfig
> > then has to become an exported symbol.
> 
> Did you build this?
> 
> As you mention above, the inlined comedi_pci_auto_unconfig() will not
> work as a function pointer in the pci_driver structs.
> 
> This cannot work until/if comedi_pci_auto_unconfig() is made an exported
> symbol. I'll leave that decision up to Ian.
> 
> Regards,
> Hartley

Hi,

yes I did build it - and it did build fine.
That's how I could find out about the size of the .kos 

On my machine all comedi .kos before the patch sum up to 9828 bytes.
After applying this patch it comes down to 9812 bytes
If I put the comedi_pci_auto_unconfig into drivers.c and export it, it comes 
down to 9752 bytes.


The gcc probably simply does not inline it anymore - inline is just a 
suggestion to the compiler.

I did some google searching before submitting it, and it seems that is indeed 
possible.
e.g.:
http://stackoverflow.com/questions/8885665/c-pointer-to-inline-function

Nevertheless I'll send a patch which moves the  comedi_pci_auto_unconfig to 
drivers.c

Thanks,
Peter



