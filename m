Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaEFNTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:19:43 -0400
Received: from mx0.aculab.com ([213.249.233.131]:58439 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751750AbaEFNTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:19:41 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Geert Uytterhoeven'" <geert@linux-m68k.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH/RFC] usb: gadget: CONFIG_USB_S3C_HSOTG should depend on
 HAS_DMA
Thread-Topic: [PATCH/RFC] usb: gadget: CONFIG_USB_S3C_HSOTG should depend on
 HAS_DMA
Thread-Index: AQHPaSoEOGIFqNQgR0C9GLltpnfBXJszh4tg
Date: Tue, 6 May 2014 13:17:21 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F70D180@AcuExch.aculab.com>
References: <1399380554-3746-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1399380554-3746-1-git-send-email-geert@linux-m68k.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven
> If NO_DMA=y:
> 
> drivers/built-in.o: In function `s3c_hsotg_map_dma':
> s3c-hsotg.c:(.text+0x375b2c): undefined reference to `usb_gadget_map_request'
> drivers/built-in.o: In function `s3c_hsotg_unmap_dma':
> s3c-hsotg.c:(.text+0x376a32): undefined reference to `usb_gadget_unmap_request'
> make[3]: *** [vmlinux] Error 1
> 
> Note that all callers of s3c_hsotg_map_dma()/s3c_hsotg_unmap_dma() are
> protected by a call into the using_dma() checking function:
> 
> static inline bool using_dma(struct s3c_hsotg *hsotg)
> {
>         return false;   /* support is not complete */
> }
> 
> but not all versions of gcc manage to optimize the check away, causing a
> link error.

A have seen gcc optimise away a call, but leave the undefined symbol
in the symbol table.
That might be what is happening here.

I don't know a generic solution, I used 'objcopy -N__udivdi3' to remove
the explicit unwanted reference from my driver.

	David



