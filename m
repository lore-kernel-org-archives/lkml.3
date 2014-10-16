Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaJPPxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:53:12 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47441 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJPPxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:53:10 -0400
Date: Thu, 16 Oct 2014 23:52:52 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Iwo Mergler <Iwo.Mergler@netcommwireless.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Mike Voytovich <mvoytovich@paypal.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Roy Lee <roylee@paypal.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/3] mtd: nand: gpmi: add proper raw access support
Message-ID: <20141016155247.GA2284@localhost.localdomain>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
 <20141008142437.GA9912@localhost.localdomain>
 <20141008171034.1506550f@bbrezillon>
 <20141010144248.GA5107@localhost.localdomain>
 <EACD232272DA4849B060F0828564D13B44955ABE1F@ntcex01.corp.netcomm.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EACD232272DA4849B060F0828564D13B44955ABE1F@ntcex01.corp.netcomm.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 04:50:27PM +1100, Iwo Mergler wrote:
> 
> >
> > No, it doesn't seem to be correct.
> > But it's an MLC flash, so you'll most probably need to apply this patch
> > to nandbiterrs testsuite:
> >
> > http://code.bulix.org/f69wuu-87021
> >
> > This patch is flashing the block between each bitflip insertion to
> > avoid multiple write without erasure (which, AFAIK, is not supported
> > by MLC flashes).
> 
> Hi Huang,
> 
> 
> just out of interest, have you tried this on the MLC NAND without the patch?

yes. I tried. As i posted, it will failed.

> 
> I'm aware that MLC says you shouldn't write multiple times, but that is
> with a view towards specified data endurance. I would only expect a few
> additional bit errors during the test.
> 
> Did you try the overwrite test?
not yet. I can test it tomorrow.

> 
> I'm curious how MLC NAND does when subjected to multiple writes.
We should not do the multiple writes to the MLC nand. 
We can do so with the SLC nand.

thank
Huang Shijie
