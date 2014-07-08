Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaGHCfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:35:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48359 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaGHCfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:35:06 -0400
Date: Mon, 07 Jul 2014 19:35:05 -0700 (PDT)
Message-Id: <20140707.193505.345276817146527821.davem@davemloft.net>
To: decot@googlers.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, edumazet@google.com, amwang@redhat.com,
        antonio@meshcoding.com, jpirko@redhat.com
Subject: Re: [PATCH net-next v1 2/2] netpoll: avoid reference leaks
From: David Miller <davem@davemloft.net>
In-Reply-To: <f98ccbfee35a7ab7f9499ede9b34e6b1120d88f1.1404172155.git.decot@googlers.com>
References: <0f692012238337f2c40893319830ae042523ce18.1404172155.git.decot@googlers.com>
	<cover.1404172155.git.decot@googlers.com>
	<f98ccbfee35a7ab7f9499ede9b34e6b1120d88f1.1404172155.git.decot@googlers.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Jul 2014 19:35:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>
Date: Mon, 30 Jun 2014 16:50:10 -0700

> This ensures that the ndo_netpoll_cleanup callback is called for every
> device that provides one. Otherwise there is a risk of reference leak
> with bonding for example, which depends on this callback to cleanup
> the slaves' references to netpoll info.
> 
> Tested:
>   see patch "netpoll: fix use after free"
> 
> Signed-off-by: David Decotigny <decot@googlers.com>

I definitely don't understand this.

Why would we call the cleanup function of an object before it's
reference count hits zero?  It is exactly the act of reaching a
zero refcount which should trigger invoking the cleanup callback.

If a refcount is being released in another location without checking
if it hits zero and invoking the cleanup if so, _THAT_ is the bug.
