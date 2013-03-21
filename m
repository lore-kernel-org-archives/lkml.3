Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab3CUMwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:52:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:49917 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab3CUMwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:52:38 -0400
Date: Thu, 21 Mar 2013 12:52:30 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] netlink: Diag core and basic socket info dumping
Message-ID: <20130321125230.GB9046@casper.infradead.org>
References: <1363857669-19990-1-git-send-email-avagin@openvz.org>
 <1363857669-19990-3-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363857669-19990-3-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/13 at 01:21pm, Andrey Vagin wrote:
> diff --git a/include/uapi/linux/netlink_diag.h b/include/uapi/linux/netlink_diag.h
> new file mode 100644
> index 0000000..9328866
> --- /dev/null
> +++ b/include/uapi/linux/netlink_diag.h
> +enum {
> +	NETLINK_DIAG_MEMINFO,
> +	NETLINK_DIAG_GROUPS,
> +
> +	NETLINK_DIAG_MAX,
> +};

Please follow the common pattern and define NETLINK_DIAG_MAX as
NETLINK_DIAG_GROUPS like other by doing>

	[...] 
        __NETLINK_DIAG_MAX,
};
 
#define NETLINK_DIAG_MAX (__NETLINK_DIAG_MAX - 1)
 
Everyone is used to do:
 
        struct nlattr *attrs[NETLINK_DIAG_MAX+1];
         
        nla_parse([...], NETLINK_DIAG_MAX, [...]

In fact, the follow-up patch to ss is buggy because of this.
UNIX_DIAG_MAX suffers from the same problem which is problem the
cause for this.
