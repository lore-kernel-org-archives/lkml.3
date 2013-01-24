Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab3AXV1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:27:47 -0500
Received: from mout.gmx.net ([212.227.15.19]:57215 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756962Ab3AXV1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:27:35 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX185wDQU81o50NjXcrEPKYKhyTC+jVMMRKRXw3AHao
	2GozTKI2WEgKU7
From: Peter Huewe <PeterHuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>
Subject: Re: [PATCH] staging/comedi: Move comedi_pci_auto_unconfig to drivers.c
Date: Thu, 24 Jan 2013 22:30:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.4; KDE/4.9.3; x86_64; ; )
Cc: Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1358894403-26181-1-git-send-email-peterhuewe@gmx.de> <1358895810-27115-1-git-send-email-peterhuewe@gmx.de> <510106BB.2080709@mev.co.uk>
In-Reply-To: <510106BB.2080709@mev.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301242230.49732.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 24. Januar 2013, 11:02:35 schrieb Ian Abbott:
> On 2013-01-22 23:03, Peter Huewe wrote:
> > Since comedi_pci_auto_unconfig cannot be inlined anymore after
> > 
> >   staging/comedi: Use comedi_pci_auto_unconfig directly for
> >   pci_driver.remove
> > 
> > is applied, it makes sense to move it drivers.c
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > ---
> > 

> Embarassingly (for me) I submitted a patch to do the exact opposite
> previously, but I've no problem doing it this way if it saves some code.

Hi Ian,
;)

If you think it's cleaner the way it is currently we can leave it like that. 
Especially if you think some driver might actually do something in the remove 
function (in the future).

However if we could also find a way to remove all the probe function stuff as 
well we should remove it.
Most (comedi pci) drivers simply call comedi_pci_auto_config and not much more 
- but I'm currently not sure how to do this ;)

Thanks,
PeterH

