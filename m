Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaJGOCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:02:15 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:54651 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaJGOCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:02:14 -0400
MIME-Version: 1.0
In-Reply-To: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
References: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
Date: Tue, 7 Oct 2014 11:02:11 -0300
Message-ID: <CAOMZO5D1f_oRm=PSukMeHPv2wW2wXR6_qp=Hz-s6Z25dwXo0Tw@mail.gmail.com>
Subject: Re: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Lothar_Wa=C3=9Fmann?= <LW@karo-electronics.de>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lothar,

On Tue, Oct 7, 2014 at 10:19 AM, Lothar Waßmann <LW@karo-electronics.de> wrote:
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

Yesterday night I was using linux-next on mx28evk and could not boot from NFS.

I haven't had a chance to debug it, but I am glad you found a fix.

Won't be able to have access to my mx28evk until Thursday to test it though.

Thanks
