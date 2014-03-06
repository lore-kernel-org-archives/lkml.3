Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaCFFFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 00:05:22 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53131 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaCFFFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 00:05:20 -0500
Date: Thu, 06 Mar 2014 00:05:18 -0500 (EST)
Message-Id: <20140306.000518.449808421540608140.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2 12/13] r8152: add additional parameter for
 non x86 platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394002168-3193-13-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	<1394002168-3193-1-git-send-email-hayeswang@realtek.com>
	<1394002168-3193-13-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Mar 2014 21:05:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 5 Mar 2014 14:49:27 +0800

> Add additional parameter for non x86 platform for better throughput.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

This commit message tells me absolutely nothing.

First of all, it doesn't say what the issue is, why is the chip
slower on non-x86 platforms with the current way it is programmed?

And in particular, which non-x86 platform?  You can't possibly mean
all of them.

I can almost guarentee if you actually explain the issue, I'm going
to tell you to use a more meaningful test for the condition or
property an architecture has which makes the alternative setting
more desirable.

>  /* USB_RX_EARLY_AGG */
> -#define EARLY_AGG_SUPPER	0x0e832981
> +#if defined(__i386__) || defined(__x86_64__)
> +	#define EARLY_AGG_SUPPER	0x0e832981
> +#else
> +	#define EARLY_AGG_SUPPER	0x0e835000
> +#endif

And this value is completely magic, you must document what this
register value means.

I find this patch series extremely frustrating.

You are combining so many things all at once, so if one aspect
requires changes or to be removed, it invalidates the rest of
the series and you have to respin it all over again.

Why don't you re-submit this in pieces?  First the cleanups
(first three patches) would be one series.

Once I apply that, perhaps submit the locking changes and
tso/checksum support.

Then finally, after I apply that, submit the tweaks at the end.

Thank you.
