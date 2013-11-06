Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab3KFJbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:31:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43824 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab3KFJbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:31:11 -0500
Date: Wed, 6 Nov 2013 12:30:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [patch] drivers: phy: tweaks to phy_create()
Message-ID: <20131106093050.GG20521@mwanda>
References: <20131106075412.GB13475@elgon.mountain>
 <5279F9AE.303@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5279F9AE.303@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 01:41:26PM +0530, Kishon Vijay Abraham I wrote:

> >The rest of this patch is just cleanup like returning directly instead
> >of having do-nothing gotos.  Using descriptive labels instead of
> 
> Grouping the err returns in the end looked a bit cleaner to me. It's
> just a matter of preference I guess.

Say if you are reading the code and it says:

	goto err0;

What you think is, "Huh, that's a crap name for a label.  I wonder what
it does?"  So you have interrupt what you are doing and scroll down and
then you see that it doesn't do anything.  Not a single thing.  It just
returns.  Then you have to scroll back and try remember where you were.

But if you use a clear label like:

	ret = -ENOMEM;
	goto return_ret;

Then I don't have to scroll down to find out what it is.

But it's even more clear to just say:

	return -ENOMEM;

The original code was not just messy, it was also buggy.  If you do the
error handling in the right way by unwinding in the correct order and
thinking about label names then your code will be less buggy.

regards,
dan carpenter
