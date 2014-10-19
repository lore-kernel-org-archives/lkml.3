Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaJSCU4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 22:20:56 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63134 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaJSCUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 22:20:55 -0400
Date: Sun, 19 Oct 2014 10:20:38 +0800
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
Message-ID: <20141019022035.GA1412@localhost.localdomain>
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
> 
> I'm aware that MLC says you shouldn't write multiple times, but that is
> with a view towards specified data endurance. I would only expect a few
> additional bit errors during the test.
> 
> Did you try the overwrite test?
> 
The following is the test result for overwrite with this MLC patch:

root@imx6qdlsolo:~# insmod mtd_nandbiterrs.ko dev=1 mode=1
[  762.534714] 
[  762.536259] ==================================================
[  762.542115] mtd_nandbiterrs: MTD device: 1
[  762.546326] mtd_nandbiterrs: MTD device size 16777216,
	eraseblock=2097152, page=8192, oob=744
	[  762.554937] mtd_nandbiterrs: Device uses 1 subpages of 8192
	bytes
	[  762.561059] mtd_nandbiterrs: Using page=0, offset=0,
	eraseblock=0
	[  762.571333] mtd_nandbiterrs: overwrite biterrors test
	[  762.576715] mtd_nandbiterrs: write_page
	[  762.590448] mtd_nandbiterrs: error: read failed at 0x0
	[  762.595650] mtd_nandbiterrs: Read reported error -74
	[  762.600625] mtd_nandbiterrs: Bit error histogram (0
			operations total):
	[  762.608586] mtd_nandbiterrs: finished successfully.
	[  762.613501]
	==================================================
	insmod: ERROR: could not insert module mtd_nandbiterrs.ko:
	Input/output error


thanks	   

Huang Shijie
