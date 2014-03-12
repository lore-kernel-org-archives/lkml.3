Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbaCLSLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:11:34 -0400
Received: from senator.holtmann.net ([87.106.208.187]:60169 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbaCLSLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:11:31 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH V2 bluetooth-next 2/6] bluetooth: Convert uses of __constant_<foo> to <foo>
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1394646755.3915.8.camel@joe-AO722>
Date: Wed, 12 Mar 2014 11:11:13 -0700
Cc: Network Development <netdev@vger.kernel.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <34E193D0-F15B-4C23-83F7-697096916D4D@holtmann.org>
References: <cover.1394643455.git.joe@perches.com> <51892631f2289665bf47b294c783ee9560a8317e.1394643455.git.joe@perches.com> <F2E9571C-2D55-4529-A361-D8CD4B3FC491@holtmann.org> <1394646755.3915.8.camel@joe-AO722>
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> The use of __constant_<foo> has been unnecessary for quite awhile now.
> 
> Make these uses consistent with the rest of the kernel.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
>> can you please send this one against bluetooth-next tree.
> 
> Sure.  Here.  btw:
> 
> The bandwidth uses of 0x1f40 are kind of unreadable to me.
> I think they'd be better as 8000
> 
> Also some of the hex constants uses seem odd where comments
> don't seem to match the number like: 
> 
> 	/* Connection accept timeout ~20 secs */
> -	param = __constant_cpu_to_le16(0x7d00);
> +	param = cpu_to_le16(0x7d00);
> 
> 0x7d00 is 32000, presumably that's 32 seconds.

so it is 0x7d00 * 0.625 which results in 20 seconds.

> 
> and
> 
> 		/* 160 msec page scan interval */
> -		acp.interval = __constant_cpu_to_le16(0x0100);
> +		acp.interval = cpu_to_le16(0x0100);
> 
> 256 msecs?

also here 0x0100 * 0.625 resulting in 160 msecs.

> net/bluetooth/a2mp.c        |  4 +-
> net/bluetooth/hci_conn.c    | 26 ++++++-------
> net/bluetooth/hci_core.c    |  2 +-
> net/bluetooth/hci_event.c   |  6 +--
> net/bluetooth/hci_sock.c    | 16 ++++----
> net/bluetooth/l2cap_core.c  | 90 ++++++++++++++++++++++-----------------------
> net/bluetooth/l2cap_sock.c  |  6 +--
> net/bluetooth/mgmt.c        | 26 ++++++-------
> net/bluetooth/rfcomm/core.c |  4 +-
> net/bluetooth/sco.c         | 10 ++---
> net/bluetooth/smp.c         |  2 +-
> 11 files changed, 96 insertions(+), 96 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

