Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaKDK30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:29:26 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:49173 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaKDK3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:29:22 -0500
Date: Tue, 4 Nov 2014 11:29:12 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: David Miller <davem@davemloft.net>
Cc: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>,
        fabio.estevam@freescale.com, Frank.Li@freescale.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: Re: net: fec: fix regression on i.MX28 introduced by rx_copybreak
 support
Message-ID: <20141104112912.2be8bf1a@ipc1.ka-ro>
In-Reply-To: <20141031063210.69004315@ipc1.ka-ro>
References: <1414502584-10583-1-git-send-email-LW@KARO-electronics.de>
	<20141029.153430.1036004676442879956.davem@davemloft.net>
	<20141030075104.05e44b43@ipc1.ka-ro>
	<20141030.121710.1524000348187962764.davem@davemloft.net>
	<20141031063210.69004315@ipc1.ka-ro>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Lothar Waßmann wrote:
> David Miller wrote:
> > From: Lothar Waßmann <LW@KARO-electronics.de>
> > Date: Thu, 30 Oct 2014 07:51:04 +0100
> > 
> > >> Also, I don't thnk your DIV_ROUND_UP() eliminate for the loop
> > >> in swap_buffer() is valid.  The whole point is that the current
> > >> code handles buffers which have a length which is not a multiple
> > >> of 4 properly, after your change it will no longer do so.
> > >>
> > > Do you really think so?
> > 
> > Yes, because you're rounding down so you'll miss the final
> > partial word (if any).
> >
> Nope. DIV_ROUND_UP() would give '1' as upper bound for lengths from 1 to
> 4, '2' for lengths from 5 to 8 and so on.
> 
> The loop with increment 4 and i < len does exactly the same.
> Try it for yourself, if you don't believe it.
> 
> 
Do you still think, the loop without DIV_ROUND_UP() is incorrect,
or can this patch be applied?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
