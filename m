Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3FARLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 13:11:53 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:50752 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3FARLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 13:11:40 -0400
Date: Sat, 1 Jun 2013 19:11:25 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, balbi@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] usb: musb: Fix format specifier warning
Message-ID: <20130601171125.GA8824@debian>
References: <1370031778-25965-1-git-send-email-emilgoode@gmail.com>
 <CAHp75VciHQKcyj-ANLdg=mg2C71zn=09Eentf22q+otGu=rp3w@mail.gmail.com>
 <51A926A4.5010800@infradead.org>
 <CAHp75Vd3frBwPa=DQiKrkkcPdOooBGUS=tYC6STw+o1gW1zf6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vd3frBwPa=DQiKrkkcPdOooBGUS=tYC6STw+o1gW1zf6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank's for your pointers.
I will send a patch that applies on top of Felipe's patch.

Best regards,

Emil Goode

On Sat, Jun 01, 2013 at 04:15:03PM +0300, Andy Shevchenko wrote:
> On Sat, Jun 1, 2013 at 1:39 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> > On 05/31/13 15:34, Andy Shevchenko wrote:
> >> On Fri, May 31, 2013 at 11:22 PM, Emil Goode <emilgoode@gmail.com> wrote:
> >>> This patch fixes a format specifier warning. dma_addr_t can be either
> >>> u32 or u64 so we should cast to the largest type and change the format
> >>> specifier to %llx.
> >>
> >> dma_addr_t is derived from phys_addr_t, thus you may use %pa specifier
> >> which is available from v3.8(?).
> >>
> >> Something like this:
> >> dma_addr_t src_addr;
> >> dev_dbg(dev, "DMA addr: %pa\n", src_addr);
> >
> > Isn't that:
> >
> >   deb_dbg(dev, "DMA addr: %pa\n", &src_addr);
> 
> It's.
> You are right.
> 
> --
> With Best Regards,
> Andy Shevchenko
