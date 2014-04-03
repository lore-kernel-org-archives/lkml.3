Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaDCSCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:02:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45887 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaDCSBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:01:54 -0400
Date: Thu, 03 Apr 2014 14:03:24 -0400 (EDT)
Message-Id: <20140403.140324.1744832114380351572.davem@davemloft.net>
To: dh.herrmann@gmail.com
Cc: netdev@vger.kernel.org, teg@jklm.no, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org
Subject: Re: [PATCH v6 0/4] Provide netdev naming-policy via sysfs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396432706-14470-1-git-send-email-dh.herrmann@gmail.com>
References: <1396432706-14470-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Apr 2014 11:01:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Herrmann <dh.herrmann@gmail.com>
Date: Wed,  2 Apr 2014 11:58:22 +0200

> This is v6 of the name_assign_type attribute for netdevs. Changes since v5 [1]:
>  - Acked-by: Kay Sievers
>  - rebased on net-next of today
> 
> Aimed for 3.15, but feel free to delay for 3.16 if you want it in -next for some
> more time.

I'm fine with the basic idea, but the implementation needs work and
this will be deferred to 3.16 in any event.

We really need to specify the name allocation type at alloc_netdev()
time, I know that's more work but that's the only way you can be sure
you caught all such cases.

I know you missed the ISDN layer, where the name can come from the
user via an ioctl().  I'm sure there were several more.

You can even do something like make alloc_netdev_enumerated()
be a shorthand for alloc_netdev(size, name, NET_NAME_ENUM, ...)

Thanks.
