Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3KUPJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:09:19 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:52698 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3KUPJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:09:17 -0500
Message-ID: <528E221A.6090307@greyhouse.net>
Date: Thu, 21 Nov 2013 10:09:14 -0500
From: Andy Gospodarek <andy@greyhouse.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Anton Nayshtut <Anton.Nayshtut@wilocity.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Eric Dumazet <edumazet@google.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] bonding: L2DA mode
References: <1385045738-29726-1-git-send-email-Anton.Nayshtut@wilocity.com>
In-Reply-To: <1385045738-29726-1-git-send-email-Anton.Nayshtut@wilocity.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 09:55 AM, Anton Nayshtut wrote:
> L2 Destination Address based (L2DA) mode allows bonding to send packets using
> different slaves according to packets L2 Destination Address.
>
> In L2DA mode, the bonding maintains a default slave and DA/slave map.
>
> Upon a packet transmission, the bonding examines DA of the packet and tries to
> find a corresponding slave within the map. If found, the slave is used for the
> packet transmission. Otherwise, the default slave is used. If the default slave
> is unable to transmit at this moment, the bonding tries to fall back to an
> arbitrary slave that can transmit.
>
> Both the default slave and the map can be controlled via sysfs or by ioctls.
>
> Anton Nayshtut (4):
>    bonding: L2DA mode added
>    bonding: L2DA mode intergated
>    bonding: L2DA command IOCTL
>    bonding: L2DA query IOCTL
>
>   drivers/net/bonding/Makefile       |   2 +-
>   drivers/net/bonding/bond_l2da.c    | 425 +++++++++++++++++++++++++++++++++++++
>   drivers/net/bonding/bond_l2da.h    |  56 +++++
>   drivers/net/bonding/bond_main.c    | 172 ++++++++++++++-
>   drivers/net/bonding/bond_options.c |  17 +-
>   drivers/net/bonding/bond_sysfs.c   | 223 ++++++++++++++++++-
>   drivers/net/bonding/bonding.h      |   7 +
>   include/uapi/linux/if_bonding.h    |  32 +++
>   include/uapi/linux/sockios.h       |   4 +-
>   net/core/dev_ioctl.c               |   4 +
>   net/socket.c                       |   4 +
>   11 files changed, 937 insertions(+), 9 deletions(-)
>   create mode 100644 drivers/net/bonding/bond_l2da.c
>   create mode 100644 drivers/net/bonding/bond_l2da.h
>

I have not done a full review of this, but I notice right away that 
there are no patches to Documentation/networking/bonding.txt.  You can 
wait until there are more comments before submitting a v2 of this 
series, but please make sure it includes a documentation update when 
submitted.
