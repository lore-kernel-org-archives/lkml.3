Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaDDODd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:03:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51921 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaDDODD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:03:03 -0400
Date: Fri, 04 Apr 2014 10:04:38 -0400 (EDT)
Message-Id: <20140404.100438.264462269855449623.davem@davemloft.net>
To: zheng.x.li@oracle.com
Cc: netdev@vger.kernel.org, j.vosburgh@gmail.com, fubar@us.ibm.com,
        andy@greyhouse.net, vfalico@redhat.com, linux-kernel@vger.kernel.org,
        joe.jin@oracle.com
Subject: Re: [PATCH v3] bonding: Inactive slaves should keep inactive
 flag's value
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396407708-4056-1-git-send-email-zheng.x.li@oracle.com>
References: <1396407708-4056-1-git-send-email-zheng.x.li@oracle.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Apr 2014 07:03:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Li <zheng.x.li@oracle.com>
Date: Wed,  2 Apr 2014 11:01:48 +0800

> bond_open is not setting the inactive flag correctly for some modes (alb and
> tlb), resulting in error behavior if the bond has been administratively set
> down and then back up. This effect should not occur when slaves are added while
> the bond is up; it's something that only happens after a down/up bounce of the
> bond.
> 
> For example, in bond tlb or alb mode, domu send some ARP request which go out
> from dom0 bond's active slave, then the ARP broadcast request packets go back to
> inactive slave from switch, because the inactive slave's inactive flag is zero,
> kernel will receive the packets and pass them to bridge that cause dom0's bridge
> map domu's MAC address to port of bond, bridge should map domu's MAC to port of
> vif.
> 
> Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
> Signed-off-by: Jay Vosburgh <j.vosburgh@gmail.com>

Applied.
