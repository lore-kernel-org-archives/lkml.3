Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaHYJhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:37:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38237 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaHYJhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:37:09 -0400
Date: Mon, 25 Aug 2014 12:36:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>, netdev@vger.kernel.org,
        devel@linuxdriverproject.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
Message-ID: <20140825093648.GB5046@mwanda>
References: <20140819123655.GC12160@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819123655.GC12160@sucs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code here is:

drivers/hv/channel.c
   460          BUG_ON(ret != 0);
   461          t = wait_for_completion_timeout(&info->waitevent, 5*HZ);
   462          BUG_ON(t == 0);

So it calls BUG_ON() if the teardown takes more than 5 seconds.  It's
most likely that there is a race condition somewhere.  It's also
possible that it's just taking longer than 5 seconds for some odd
reason and the bug would go away if we raised it to 60 seconds.

BUG_ON() after 5 seconds seems like a very aggressive thing.

regards,
dan carpenter

