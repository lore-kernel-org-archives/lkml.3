Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaJGORL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:17:11 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50066 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaJGORI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:17:08 -0400
Date: Tue, 7 Oct 2014 16:17:02 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        "Fabio Estevam" <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Message-ID: <20141007161702.7cd1e800@ipc1.ka-ro>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D174C6025@AcuExch.aculab.com>
References: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
	<063D6719AE5E284EB5DD2968C1650D6D174C6025@AcuExch.aculab.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Laight wrote:
> From: Lothar Waßmann
> > commit 1b7bde6d659d ("net: fec: implement rx_copybreak to improve rx performance")
> > introduced a regression for i.MX28. The swap_buffer() function doing
> > the endian conversion of the received data on i.MX28 may access memory
> > beyond the actual packet size in the DMA buffer. fec_enet_copybreak()
> > does not copy those bytes, so that the last bytes of a packet may be
> > filled with invalid data after swapping.
> > This will likely lead to checksum errors on received packets.
> > E.g. when trying to mount an NFS rootfs:
> > UDP: bad checksum. From 192.168.1.225:111 to 192.168.100.73:44662 ulen 36
> > 
> > Do the byte swapping and copying to the new skb in one go if
> > necessary.
> 
> ISTM that if you need to do the 'swap' you should copy the data regardless
> of the length.
> 
The swap function has to look at at most 3 bytes beyond the actual
packet length. That is what the original swap_buffer() function does and
what the new function swap_buffer2(), that does the endian swapping
while copying to the new buffer, also does.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
