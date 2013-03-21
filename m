Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab3CUOlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:41:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:50660 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab3CUOlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:41:22 -0400
Date: Thu, 21 Mar 2013 14:41:20 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Andrew Vagin <avagin@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] netlink: Diag core and basic socket info dumping
Message-ID: <20130321144120.GE9046@casper.infradead.org>
References: <1363857669-19990-1-git-send-email-avagin@openvz.org>
 <1363857669-19990-3-git-send-email-avagin@openvz.org>
 <20130321125230.GB9046@casper.infradead.org>
 <20130321143119.GA14763@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321143119.GA14763@paralelels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/13 at 06:31pm, Andrew Vagin wrote:
> The code in ss looks like you described:
>         struct rtattr *tb[UNIX_DIAG_MAX+1];
> ...
>         parse_rtattr(tb, UNIX_DIAG_MAX, (struct rtattr*)(r+1),
>                      nlh->nlmsg_len - NLMSG_LENGTH(sizeof(*r)));
> 
> 
>         struct rtattr *tb[NETLINK_DIAG_MAX+1];
> ...
>         parse_rtattr(tb, NETLINK_DIAG_MAX, (struct rtattr*)(r+1),
>                      nlh->nlmsg_len - NLMSG_LENGTH(sizeof(*r)))
> 
> I think I should only update headers... Or I don't understand something.

Right, fixing the headers will resolve the issue.
