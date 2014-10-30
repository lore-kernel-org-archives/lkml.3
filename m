Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbaJ3Gv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:51:27 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:53330 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaJ3Gv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:51:26 -0400
Date: Thu, 30 Oct 2014 07:51:04 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        Frank.Li@freescale.com, fabio.estevam@freescale.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: fec: fix regression on i.MX28 introduced by rx_copybreak
 support
Message-ID: <20141030075104.05e44b43@ipc1.ka-ro>
In-Reply-To: <20141029.153430.1036004676442879956.davem@davemloft.net>
References: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
	<1414502584-10583-1-git-send-email-LW@KARO-electronics.de>
	<20141029.153430.1036004676442879956.davem@davemloft.net>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Miller wrote:
> From: Lothar Waßmann <LW@KARO-electronics.de>
> Date: Tue, 28 Oct 2014 14:22:55 +0100
> 
> > Changes wrt. v1:
> > - added some cleanup patches
> > - simplify handling of 'quirks' flags as suggested by Russell King.
> > - remove DIV_ROUND_UP() from byte swapping loop as suggested by
> >   Eric Dumazet
> > 
> > Changes wrt. v2:
> > - rebased against next-20141028
> > - added some more cleanups in fec.h
> > - removed unused return value from swap_buffer()
> > - fixed messed swab32s() call in swap_buffer2()
> > - fixed messed up setup of fep->quirks
> > 
> 
> It is not appropriate to mix cleanups and bonafide bug fixes.
> 
> I want to see only bug fixes targetted at 'net'.  You can later
> submit the cleanups to 'net-next'.
> 
OK.

> Also, I don't thnk your DIV_ROUND_UP() eliminate for the loop
> in swap_buffer() is valid.  The whole point is that the current
> code handles buffers which have a length which is not a multiple
> of 4 properly, after your change it will no longer do so.
>
Do you really think so?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
