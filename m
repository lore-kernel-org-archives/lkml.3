Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3GBErU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 00:47:20 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54542 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3GBErS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:47:18 -0400
Date: Tue, 2 Jul 2013 12:46:41 +0800
From: Wang YanQing <udknight@gmail.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz, alan@linux.intel.com,
        matts@commtech-fastcom.com, wfp5p@virginia.edu, tklauser@distanz.ch,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v3.9] [v3.10] [Regression]  serial: 8250_pci: add support for
 another kind of NetMos Technology PCI 9835 Multi-I/O Controller
Message-ID: <20130702044641.GA6549@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Joseph Salisbury <joseph.salisbury@canonical.com>,
	Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
	alan@linux.intel.com, matts@commtech-fastcom.com,
	wfp5p@virginia.edu, tklauser@distanz.ch,
	linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <51D1AAF5.5050004@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D1AAF5.5050004@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 12:14:45PM -0400, Joseph Salisbury wrote:
> Hi Wang,
> 
> A bug was opened against the Ubuntu kernel[0].  After a kernel bisect,
> it was found that reverting the following commit resolved this bug:
> 
> commit 8d2f8cd424ca0b99001f3ff4f5db87c4e525f366
> Author: Wang YanQing <udknight@gmail.com>
> Date:   Fri Mar 1 11:47:20 2013 +0800
> 
>     serial: 8250_pci: add support for another kind of NetMos Technology
> PCI 9835 Multi-I/O Controller
> 
> 
> The regression was introduced as of v3.9-rc3 and still exists in the
> current Mainline tree.  It was also propagated to the stable trees.
> 
> The patch causes the device to use the serial module instead of
> parport_serial.  Maybe the the quirk in ~drivers/pci/quirks.c
> quirk_netmos() needs to be modified?
> 
> I see that you are the author of this patch, so I wanted to run this by
> you.  I was thinking of requesting a revert, but I wanted to get your
> feedback first.
> 
> 
> Thanks,
> 
> Joe
Hi all,
I am sorry for it and later reply.

But I am sure I have included the parport_serial in the
kernel for my consumers at the time they report their
PCI 9835 Multi-I/O Controller didn't work which cause
this "culprit" patch.

I don't have the card in hand right now, so I can't
dig into it. After stare into parport_serial.c, yes,
it seems like it will handle this pci serial card.

Maybe I forget or miss something, I hope.

Thanks.
