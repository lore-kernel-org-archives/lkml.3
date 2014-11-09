Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaKIBmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 20:42:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54221 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaKIBmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 20:42:07 -0500
Date: Sat, 08 Nov 2014 20:42:02 -0500 (EST)
Message-Id: <20141108.204202.2273082249078358608.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gerrit@erg.abdn.ac.uk
Subject: Re: [PATCH net-next] dccp: Convert DCCP_WARN to
 net_warn_ratelimited
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415307221.21526.0.camel@perches.com>
References: <1415230929.6634.38.camel@perches.com>
	<20141106.151149.1321164537677873976.davem@davemloft.net>
	<1415307221.21526.0.camel@perches.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Nov 2014 17:42:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 06 Nov 2014 12:53:41 -0800

> Remove the dependency on the "warning" sysctl (net_msg_warn)
> which is only used by the LIMIT_NETDEBUG macro.
> 
> Convert the LIMIT_NETDEBUG use in DCCP_WARN to the more
> common net_warn_ratelimited mechanism.
> 
> This still ratelimits based on the net_ratelimit()
> function, but removes the check for the sysctl.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.

> What about the LIMIT_NETDEBUG stuff now?
> 
> Maybe all of them might as well be net_dbg_ratelimited
> even if it changes some of the logging levels.

I think a straight conversion to net_dbg_ratelimited would
be fine.
