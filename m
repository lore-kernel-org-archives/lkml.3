Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaIBD0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 23:26:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46770 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaIBD0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 23:26:35 -0400
Date: Mon, 01 Sep 2014 20:26:32 -0700 (PDT)
Message-Id: <20140901.202632.1784070145688270115.davem@davemloft.net>
To: antoine.tenart@free-electrons.com
Cc: sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] net: mvberlin_eth: add an Ethernet driver for
 Marvell Berlin
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409320263-10295-2-git-send-email-antoine.tenart@free-electrons.com>
References: <1409320263-10295-1-git-send-email-antoine.tenart@free-electrons.com>
	<1409320263-10295-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Sep 2014 20:26:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Tenart <antoine.tenart@free-electrons.com>
Date: Fri, 29 Aug 2014 15:50:59 +0200

> +struct rx_desc {
> +	u16 buf_size;		/* Buffer size				*/
> +	u16 byte_cnt;		/* Descriptor buffer byte count		*/
 ...
> +	u16 byte_cnt;		/* buffer byte count			*/
> +	u16 l4i_chk;		/* CPU provided TCP checksum		*/

I'm really suspcious that you're ordering these two members differently
than that used by the mv643xx_eth driver.

Looking at a diff of the two drivers, most of the transmit and recieve paths
are largely the same.

WRT. register differences, adding indirection to handle that is a no-brainer
because the cost of the register access itself will absolutely dwarf whatever
it costs to do an indirect call or whatever to implement the register access.

I really think you should look into sharing code more seriously.
