Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaFBOgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:36:04 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:57660 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaFBOgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:36:01 -0400
Date: Mon, 2 Jun 2014 16:35:57 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Michal Privoznik <mprivozn@redhat.com>
Cc: davem@davemloft.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net-sysfs: Report link speed as signed integer
Message-ID: <20140602143557.GA2925@minipsycho.orion>
References: <06d53256e3bf2d0deedb16249082200500da3ee6.1401718809.git.mprivozn@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06d53256e3bf2d0deedb16249082200500da3ee6.1401718809.git.mprivozn@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, Jun 02, 2014 at 04:25:15PM CEST, mprivozn@redhat.com wrote:
>The link speed is available at /sys/class/net/$nic/speed.
>However, the speed is printed in unsigned integer format. This
>makes userspace applications read an incorrect value (which
>moreover changes through several architectures) while in fact
>'-1' should be reported.
>
>Before the change:
>  # cat /sys/class/net/eth0/speed
>  4294967295
>
>After the change:
>  # cat /sys/class/net/eth0/speed
>  -1
>
>Signed-off-by: Michal Privoznik <mprivozn@redhat.com>
>---
> net/core/net-sysfs.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>index 1cac29e..99afdea 100644
>--- a/net/core/net-sysfs.c
>+++ b/net/core/net-sysfs.c
>@@ -173,7 +173,7 @@ static ssize_t speed_show(struct device *dev,
> 	if (netif_running(netdev)) {
> 		struct ethtool_cmd cmd;
> 		if (!__ethtool_get_settings(netdev, &cmd))
>-			ret = sprintf(buf, fmt_udec, ethtool_cmd_speed(&cmd));
>+			ret = sprintf(buf, fmt_dec, ethtool_cmd_speed(&cmd));

I wonder why this should be signed. What -1 means? What driver reports
this?

> 	}
> 	rtnl_unlock();
> 	return ret;
>-- 
>2.0.0
>
