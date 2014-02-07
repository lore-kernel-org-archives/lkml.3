Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaBGEDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:03:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39795 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaBGEDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:03:01 -0500
Date: Thu, 06 Feb 2014 20:03:00 -0800 (PST)
Message-Id: <20140206.200300.862172310084916848.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: jiri@resnulli.us, cwang@twopensource.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: Fix runtime WARNING in rtmsg_ifa()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1391585905-24851-1-git-send-email-geert@linux-m68k.org>
References: <1391585905-24851-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed,  5 Feb 2014 08:38:25 +0100

> On m68k/ARAnyM:
 ...
> Adding some debugging code reveals that net_fill_ifaddr() fails in
> 
>     put_cacheinfo(skb, ifa->ifa_cstamp, ifa->ifa_tstamp,
>                               preferred, valid))
> 
> nla_put complains:
> 
>     lib/nlattr.c:454: skb_tailroom(skb) = 12, nla_total_size(attrlen) = 20
> 
> Apparently commit 5c766d642bcaffd0c2a5b354db2068515b3846cf ("ipv4:
> introduce address lifetime") forgot to take into account the addition of
> struct ifa_cacheinfo in inet_nlmsg_size(). Hence add it, like is already
> done for ipv6.
> 
> Suggested-by: Cong Wang <cwang@twopensource.com>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied and queued up for -stable, thanks!
