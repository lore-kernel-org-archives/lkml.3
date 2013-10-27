Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3J0Kdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 06:33:47 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:49777 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3J0Kdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 06:33:45 -0400
Date: Sun, 27 Oct 2013 11:33:41 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH V2] printk: pr_debug_ratelimited: check state first to
 reduce "callbacks suppressed" messages
Message-ID: <20131027103341.GA16146@shrek.podlesie.net>
References: <20131026132955.GA9251@shrek.podlesie.net>
 <20131026173730.GA18320@kroah.com>
 <1382813522.3238.4.camel@joe-AO722>
 <20131026190151.GA26389@kroah.com>
 <1382845313.3238.28.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382845313.3238.28.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 08:41:53PM -0700, Joe Perches wrote:
> pr_debug_ratelimited should be coded similarly to dev_dbg_ratelimited
> to reduce the "callbacks suppressed" messages.
> 
> Add #include <linux/dynamic_debug.h> to printk.h. Unfortunately, this
> new #include must be after the prototype/declaration of function printk.
> 
> It may be better to split out these _ratelimited declarations into
> a separate file one day.
> 
> Any use of these pr_<foo>_ratelimited functions must also have another
> specific #include <ratelimited.h>.  Most users have this done indirectly
> via #include <linux/kernel.h>
> 
> printk.h may not #include <linux/ratelimit.h> as it causes circular
> dependencies and compilation failures.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> V2: Fix #include dependencies and typos.
> 
> Compile tested with and without CONFIG_DYNAMIC_DEBUG

I've tested both patches without CONFIG_DYNAMIC_DEBUG and
with enabled and disabled debugging with CONFIG_DYNAMIC_DEBUG
and everything seems work correctly.

Thanks,
Krzysiek
