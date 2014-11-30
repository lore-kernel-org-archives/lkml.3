Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaK3EjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 23:39:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54744 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaK3EjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 23:39:16 -0500
Date: Sat, 29 Nov 2014 20:43:23 -0800 (PST)
Message-Id: <20141129.204323.1338545932639792456.davem@davemloft.net>
To: seth.forshee@canonical.com
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, zoltan.kiss@linaro.org,
        eric.dumazet@gmail.com, stefan.bader@canonical.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-netfront: Remove BUGs on paged skb data which
 crosses a page boundary
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141127035350.GA10833@ubuntu-mba51>
References: <1416968904-70874-1-git-send-email-seth.forshee@canonical.com>
	<20141126.122812.223757363894961994.davem@davemloft.net>
	<20141127035350.GA10833@ubuntu-mba51>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Nov 2014 20:39:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>
Date: Wed, 26 Nov 2014 21:53:50 -0600

> On Wed, Nov 26, 2014 at 12:28:12PM -0500, David Miller wrote:
>> From: Seth Forshee <seth.forshee@canonical.com>
>> Date: Tue, 25 Nov 2014 20:28:24 -0600
>> 
>> > These BUGs can be erroneously triggered by frags which refer to
>> > tail pages within a compound page. The data in these pages may
>> > overrun the hardware page while still being contained within the
>> > compound page, but since compound_order() evaluates to 0 for tail
>> > pages the assertion fails. The code already iterates through
>> > subsequent pages correctly in this scenario, so the BUGs are
>> > unnecessary and can be removed.
>> > 
>> > Fixes: f36c374782e4 ("xen/netfront: handle compound page fragments on transmit")
>> > Cc: <stable@vger.kernel.org> # 3.7+
>> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>> 
>> Can I get some Xen developer reviews?
> 
> Fwiw this issue was discussed previously and this was the recommended
> fix.
> 
>  http://article.gmane.org/gmane.linux.kernel/1825381
> 
> Since then I got some feedback from a tester that he didn't see any
> problems with the BUGs removed (actually replaced with a WARN so I know
> that he actually saw the condition which triggered the BUG).

That's fine, but I still want a xen-netfront developer to review and
ACK this.
