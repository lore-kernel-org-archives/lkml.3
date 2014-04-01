Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaDAUMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:12:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54899 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaDAUMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:12:23 -0400
Date: Tue, 01 Apr 2014 16:12:21 -0400 (EDT)
Message-Id: <20140401.161221.2203778202011452309.davem@davemloft.net>
To: zheng.x.li@oracle.com
Cc: netdev@vger.kernel.org, fubar@us.ibm.com, andy@greyhouse.net,
        j.vosburgh@gmail.com, linux-kernel@vger.kernel.org, joe.jin@oracle.com
Subject: Re: [PATCH v2] bonding: Inactive slaves should keep inactive
 flag's value
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396339327-24899-1-git-send-email-zheng.x.li@oracle.com>
References: <1396339327-24899-1-git-send-email-zheng.x.li@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Apr 2014 13:12:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Li <zheng.x.li@oracle.com>
Date: Tue,  1 Apr 2014 16:02:07 +0800

> -			if ((bond->params.mode == BOND_MODE_ACTIVEBACKUP)
> +			if ((bond->params.mode == BOND_MODE_ACTIVEBACKUP || bond_is_lb(bond))

As has been suggested, please use USES_PRIMARY() for this entire
logical test.
