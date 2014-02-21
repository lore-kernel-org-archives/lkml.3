Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbaBUQPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:15:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52205 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040AbaBUQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:15:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Cc: balbi@ti.com, Mark Rutland <mark.rutland@arm.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
Date: Fri, 21 Feb 2014 17:15:04 +0100
Message-ID: <1684019.mmMhl0O7OE@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <530775EB.6030004@monstr.eu>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local> <20140221154244.GG31902@saruman.home> <530775EB.6030004@monstr.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:16kdMkugV2iXCvfsz3mjR0KOou0CkUZ64bpbUpkVP89
 8ZHJ5sbSRfXAd1sHz8hgfxlwvf0r1W+M22RmqGnL5IjYhG3R7s
 +Dt4LbDxnTinzteFnbR+oJwqLGqHLVhMgngHiNH427orMyEj/o
 0laGdu5NRvP1bXQeyXSrjJGDCO1Mb77wtzvaoDY87adNOuw0lW
 SrBc/QBVYLTjOyLq8BnAprmZqPwwTGrkkPLzFjgYnyK0Cvt3Av
 YjoyAHX5AuVd/1yc4vEvDjt3i2ZMnYjoC36f0/zTNQjOd7ispA
 mCONO2QYKoEBJB9nZeyMdlXoiKuRMLhBpe3oYvR5ts9PjoGRnv
 ppgfw1yz/dzpMRxgGvbg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 February 2014 16:51:07 Michal Simek wrote:
> > | 
> > |     if (res->flags & IORESOURCE_CACHEABLE)
> > |             dest_ptr = devm_ioremap(dev, res->start, size);
> > |     else
> > |             dest_ptr = devm_ioremap_nocache(dev, res->start, size);
> 
> I have read it just not sure if IORESOURCE_CACHEABLE is setup by default
> or not.
> If yes, then you have to setup res->flags in your driver and have to
> check it.

ioremap() and ioremap_nocache() are the same on all architectures.
If you want a cacheable mapping, you need to call ioremap_cache(),
which unfortunately doesn't exist on all architectures and also
doesn't have a devm_* variant.

I don't know how the above code made it into devm_ioremap_resource(),
it's clearly bogus. The only time we ever set IORESOURCE_CACHEABLE
is for ROM BARs on PCI, which in turn are rarely used in the kernel.
It's never set for any platform devices, aside from one use
in arch/arm/mach-clps711x/board-cdb89712.c.

	Arnd
