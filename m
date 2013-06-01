Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3FAUb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 16:31:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41446 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751997Ab3FAUb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 16:31:26 -0400
Message-ID: <1370118685.2098.7.camel@joe-AO722>
Subject: Re: [PATCH] usb: musb: use the new %pa format specifier for
 dma_addr_t
From: Joe Perches <joe@perches.com>
To: Emil Goode <emilgoode@gmail.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sat, 01 Jun 2013 13:31:25 -0700
In-Reply-To: <20130601190926.GA5541@debian>
References: <1370109747-18821-1-git-send-email-emilgoode@gmail.com>
	 <1370111350.2098.1.camel@joe-AO722> <20130601190926.GA5541@debian>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-01 at 21:09 +0200, Emil Goode wrote:
> I see, will send a second version.

Hey Emil.

I believe you can not use %pa with a dma_addr_t
because that could be a different size than a
phy_addr_t.

(the vsprintf cast and deref is to a phy_addr_t)

The definitions are: (types.h)

#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
typedef u64 dma_addr_t;
#else
typedef u32 dma_addr_t;
#endif /* dma_addr_t */

[]

#ifdef CONFIG_PHYS_ADDR_T_64BIT
typedef u64 phys_addr_t;
#else
typedef u32 phys_addr_t;
#endif

On Sat, Jun 01, 2013 at 11:29:10AM -0700, Joe Perches wrote:
> On Sat, 2013-06-01 at 20:02 +0200, Emil Goode wrote:
> > This patch makes use of the new format specifier %pa that was introduced
> > by the following commit.
> > 
> > 7d7992108d02aa92ad4c77e5d9ce14088c942e75
> > ("lib/vsprintf.c: add %pa format specifier for phys_addr_t types")
> []
> > diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
> []
> > @@ -1756,12 +1756,11 @@ void musb_host_rx(struct musb *musb, u8 epnum)
> []
> > -                   dev_dbg(musb->controller, "RX%d count %d, buffer 0x%llx len %d/%d\n",
> > +                   dev_dbg(musb->controller, "RX%d count %d, buffer 0x%pa len %d/%d\n",
> 
> This would emit 0x0x<addr>


