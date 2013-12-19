Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3LSRnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:43:52 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:56683 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3LSRnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:43:51 -0500
Date: Thu, 19 Dec 2013 10:43:34 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Leigh Brown <leigh@solinno.co.uk>
Cc: "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Schichan <nschichan@freebox.fr>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2] net: mvmdio: fix interrupt timeout handling
Message-ID: <20131219174334.GB10227@obsidianresearch.com>
References: <52B2D97F.4070200@gmail.com>
 <1387458588-17231-1-git-send-email-leigh@solinno.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387458588-17231-1-git-send-email-leigh@solinno.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 01:09:48PM +0000, Leigh Brown wrote:
> This version corrects the whitespace issue.
> 
> orion_mdio_wait_ready uses wait_event_timeout to wait for the
> SMI interrupt to fire.  wait_event_timeout waits for between
> "timeout - 1" and "timeout" jiffies.  In this case a 1ms timeout
> when HZ is 1000 results in a wait of 0 to 1 jiffies, causing
> premature timeouts.
> 
> This fix ensures a minimum timeout of 2 jiffies, ensuring
> wait_event_timeout will always wait at least 1 jiffie.
> 
> Issue reported by Nicolas Schichan.
> 
> Tested-by: Nicolas Schichan <nschichan@freebox.fr>
> Signed-off-by: Leigh Brown <leigh@solinno.co.uk>
>  drivers/net/ethernet/marvell/mvmdio.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Leigh, I have just noticed a regression in 3.13-rc3 vs 3.10, on
kirkwood where 3.13 occasionally prints:

3 12/11 13:59:02 kernel: orion-mdio f1072004.mdio: Timeout: SMI busy for too long

Is that the same issue that this patch is addressing?

Regards,
Jason
