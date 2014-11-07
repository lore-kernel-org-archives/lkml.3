Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaKGM0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:26:22 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:63298 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaKGM0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:26:17 -0500
MIME-Version: 1.0
In-Reply-To: <1415350967-2238-2-git-send-email-LW@KARO-electronics.de>
References: <1415350967-2238-1-git-send-email-LW@KARO-electronics.de>
	<1415350967-2238-2-git-send-email-LW@KARO-electronics.de>
Date: Fri, 7 Nov 2014 10:26:15 -0200
Message-ID: <CAOMZO5Cb1=Nvzu8EHqmV+K+W+ZJxzL1=5MnK6hDSstwh9ruweA@mail.gmail.com>
Subject: Re: [PATCHv4 1/1] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Lothar_Wa=C3=9Fmann?= <LW@karo-electronics.de>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Frank Li <Frank.Li@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stefan Wahren <stefan.wahren@i2se.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2014 at 7:02 AM, Lothar Waßmann <LW@karo-electronics.de> wrote:
> commit 1b7bde6d659d ("net: fec: implement rx_copybreak to improve rx performance")
> introduced a regression for i.MX28. The swap_buffer() function doing
> the endian conversion of the received data on i.MX28 may access memory
> beyond the actual packet size in the DMA buffer. fec_enet_copybreak()
> does not copy those bytes, so that the last bytes of a packet may be
> filled with invalid data after swapping.
> This will likely lead to checksum errors on received packets.
> E.g. when trying to mount an NFS rootfs:
> UDP: bad checksum. From 192.168.1.225:111 to 192.168.100.73:44662 ulen 36
>
> Do the byte swapping and copying to the new skb in one go if
> necessary.
>
> Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>

With this patch I am able to NFS mount on mx28 again. Thanks, Lothar!

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
