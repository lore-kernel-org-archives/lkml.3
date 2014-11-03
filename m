Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaKCW6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:58:34 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:56328 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaKCW6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:58:31 -0500
Date: Mon, 3 Nov 2014 23:58:23 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: netdev@vger.kernel.org,
        =?UTF-8?Q?=22Lothar_Wa=C3=9Fmann=22?= <LW@KARO-electronics.de>
Cc: linux-kernel@vger.kernel.org, Frank Li <Frank.Li@freescale.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1415672191.1021851.1415055503664.JavaMail.open-xchange@oxbsltgw07.schlund.de>
In-Reply-To: <1414502584-10583-10-git-send-email-LW@KARO-electronics.de>
References: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de> <1414502584-10583-1-git-send-email-LW@KARO-electronics.de> <1414502584-10583-10-git-send-email-LW@KARO-electronics.de>
Subject: Re: [PATCHv3 9/9] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev23
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V02:K0:3dzE2MUeNErn24pGUD0uBdFa8Cmd/glC4M9wEoOxg5S
 aKRK82Y1/lSXTJiDn+Lv/HTdcLm+mPmkrcbw7bh+uxCC82QDNg
 rLNu08nTeA4xOYZ+6zMq3riQVXwORoSkyaiFyttq/SHd/UKnsf
 58qDXOIfMBOnPgxxAtXA2kZNp77tGTBxZtnO92FF9L7BEV2r/w
 0mHTlt12Z8bhC81X2l4ucGdMBYlXh8V99REQ2pJ1aH8X/6kKlZ
 7GNiUaDlWk5EpgxWhG3vRhlpRfKQko/obMtIzMoILzVydUfICg
 J3UzcdNYmqXUBYChp+2uc8KPIGKNNsl2yesxyiiUfNDPRCbImj
 0Si0w9+t/nIXoBaUusRijHBUjC8oidHlm5nN6FMagI9TuvG4H6
 DFBlo3qvG8SXMuuGx3URgSq1xMe9eajY4g3F5r6tlbvkK+T9BC
 Nb8SboTTGV87WW4EBWNkn1MBMqA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lothar,

> Lothar Waßmann <LW@KARO-electronics.de> hat am 28. Oktober 2014 um 14:23
> geschrieben:
>
>
> commit 1b7bde6d659d ("net: fec: implement rx_copybreak to improve rx
> performance")
> introduced a regression for i.MX28. The swap_buffer() function doing
> the endian conversion of the received data on i.MX28 may access memory
> beyond the actual packet size in the DMA buffer. fec_enet_copybreak()
> does not copy those bytes, so that the last bytes of a packet may be
> filled with invalid data after swapping.
> This will likely lead to checksum errors on received packets.
> E.g. when trying to mount an NFS rootfs:
> UDP: bad checksum. From 192.168.1.225:111 to 192.168.100.73:44662 ulen 36

i think i experience the same problem with 3.18-rc2 on my mx28 board. I get
strange warnings about unexpected bytes from ping on my mx28 board and ping to
my mx28 board fails because of no response.

After applying the complete patch series these problems disappear. I'm looking
forward to see V4.

Thanks Stefan
