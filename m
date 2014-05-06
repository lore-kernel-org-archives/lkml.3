Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbaEFDIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:08:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35901 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaEFDIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:08:31 -0400
Date: Mon, 05 May 2014 23:08:30 -0400 (EDT)
Message-Id: <20140505.230830.1291070654883866275.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 12/24] net, diet: Make rtnetlink optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399328773-6531-13-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<1399328773-6531-13-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:08:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon,  5 May 2014 15:26:01 -0700

> From: Andi Kleen <ak@linux.intel.com>
> 
> Small systems can use ioctl/ifconfig for routing and
> interface configuration. Make rtnetlink optional
> This saves ~29k without LTO, more with LTO.
> 
>    text    data     bss     dec     hex filename
>  483545   19371   13480  516396   7e12c net/built-in.o-with-rtnetlink
>  454365   19275   12936  486576   76cb0 net/built-in.o-wo-rtnetlink
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Andi, I've had about enough with this patch series.

We have moved several tools to only use netlink because it's
the only extensible facility, and we are not looking back.

The moment one of these "small" systems, or whatever you want to call
it, tries to use any feature added to device configuration in the last
20 years ioctl doesn't cut it.
