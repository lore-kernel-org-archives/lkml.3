Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbaDNQvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:51:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56062 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbaDNQvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:51:36 -0400
Date: Mon, 14 Apr 2014 12:51:31 -0400 (EDT)
Message-Id: <20140414.125131.1934050779129550948.davem@davemloft.net>
To: david.vrabel@citrix.com
Cc: v.maffione@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com
Subject: Re: [Xen-devel] [PATCH] drivers: net: xen-netfront: fix array
 initialization bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <534BAD7C.6090107@citrix.com>
References: <1397296540-3007-1-git-send-email-v.maffione@gmail.com>
	<20140412.165152.1877473530496221304.davem@davemloft.net>
	<534BAD7C.6090107@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Apr 2014 09:51:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>
Date: Mon, 14 Apr 2014 10:42:20 +0100

> On 12/04/14 21:51, David Miller wrote:
>> From: Vincenzo Maffione <v.maffione@gmail.com>
>> Date: Sat, 12 Apr 2014 11:55:40 +0200
>> 
>>> This patch fixes the initialization of an array used in the TX
>>> datapath that was mistakenly initialized together with the
>>> RX datapath arrays. An out of range array access could happen
>>> when RX and TX rings had different sizes.
>>>
>>> Signed-off-by: Vincenzo Maffione <v.maffione@gmail.com>
>> 
>> Good catch, applied, thanks.
> 
> Thanks.  You can queue this for net-next since the Tx and Rx rings are
> the same constant size.

I was able to determine when I reviewed this patch that the size in bytes
of the rings are the same (PAGE_SIZE), but I couldn't ascertain whether
the individual ring entries in the TX ring and RX ring are the same size.

Are they?
