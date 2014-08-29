Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaH2KkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:40:11 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:56718 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaH2KkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:40:09 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Fri, 29 Aug 2014 12:38:45 +0200
From: Johan Hovold <johan@kernel.org>
To: Wang YanQing <udknight@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, jhovold@gmail.com, andi@lisas.de,
        dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Resend Re: [PATCH v6] usb:serial:pl2303: add GPIOs interface on
 PL2303
Message-ID: <20140829103845.GG4894@localhost>
References: <20140729165709.GA3380@udknight>
 <20140804140032.GA25529@localhost>
 <20140804171536.GA2330@udknight>
 <20140805135408.GD25529@localhost>
 <20140807191034.GA6335@udknight>
 <20140808075442.GB14553@localhost>
 <20140808184655.GA20958@udknight>
 <20140812140259.GA9799@localhost>
 <20140827233810.GA418@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827233810.GA418@localhost.localdomain>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 07:38:10AM +0800, Wang YanQing wrote:
> On Tue, Aug 12, 2014 at 04:02:59PM +0200, Johan Hovold wrote:
> > On Sat, Aug 09, 2014 at 02:46:56AM +0800, Wang YanQing wrote:
> > > On Fri, Aug 08, 2014 at 09:54:42AM +0200, Johan Hovold wrote:
> > > > On Fri, Aug 08, 2014 at 03:10:34AM +0800, Wang YanQing wrote:

> > > "
> > > You must allocate the buffer dynamically as some platforms cannot do
> > > DMA to the stack.
> > > "
> > > Thanks very much for point out it, could you clarify it? 
> > > I want to know the reason.
> > 
> > The memory where the stack resides might not be available for DMA, and
> > even if it is, there could still be problems with cache coherency.
> 
> It is still vague:
> stack memory maybe resident higher place than normal memory,
> but I don't think kmalloc could be immune from this problem, unless
> we use GFP_DMA?

No, you don't need to use GFP_DMA (unless implementing a driver for an
ISA device on x86).

Have a look at Documentation/DMA-API-HOWTO.txt, specifically the section
"What memory is DMA'able?".

Johan
