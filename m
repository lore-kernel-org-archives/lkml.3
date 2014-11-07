Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaKGRJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:09:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40248 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKGRJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:09:33 -0500
Date: Fri, 07 Nov 2014 12:09:26 -0500 (EST)
Message-Id: <20141107.120926.297493918093719160.davem@davemloft.net>
To: festevam@gmail.com
Cc: LW@karo-electronics.de, netdev@vger.kernel.org,
        fabio.estevam@freescale.com, Frank.Li@freescale.com,
        linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, stefan.wahren@i2se.com
Subject: Re: [PATCHv4 1/1] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOMZO5Cb1=Nvzu8EHqmV+K+W+ZJxzL1=5MnK6hDSstwh9ruweA@mail.gmail.com>
References: <1415350967-2238-1-git-send-email-LW@KARO-electronics.de>
	<1415350967-2238-2-git-send-email-LW@KARO-electronics.de>
	<CAOMZO5Cb1=Nvzu8EHqmV+K+W+ZJxzL1=5MnK6hDSstwh9ruweA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Nov 2014 09:09:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>
Date: Fri, 7 Nov 2014 10:26:15 -0200

> On Fri, Nov 7, 2014 at 7:02 AM, Lothar Waﬂmann <LW@karo-electronics.de> wrote:
>> commit 1b7bde6d659d ("net: fec: implement rx_copybreak to improve rx performance")
>> introduced a regression for i.MX28. The swap_buffer() function doing
>> the endian conversion of the received data on i.MX28 may access memory
>> beyond the actual packet size in the DMA buffer. fec_enet_copybreak()
>> does not copy those bytes, so that the last bytes of a packet may be
>> filled with invalid data after swapping.
>> This will likely lead to checksum errors on received packets.
>> E.g. when trying to mount an NFS rootfs:
>> UDP: bad checksum. From 192.168.1.225:111 to 192.168.100.73:44662 ulen 36
>>
>> Do the byte swapping and copying to the new skb in one go if
>> necessary.
>>
>> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> 
> With this patch I am able to NFS mount on mx28 again. Thanks, Lothar!
> 
> Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

Applied, thanks everyone.
