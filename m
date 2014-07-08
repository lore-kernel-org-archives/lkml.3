Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaGHVRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:17:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54277 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbaGHVRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:17:09 -0400
Date: Tue, 08 Jul 2014 14:17:08 -0700 (PDT)
Message-Id: <20140708.141708.2064358397103630362.davem@davemloft.net>
To: decot@googlers.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, edumazet@google.com, amwang@redhat.com,
        antonio@meshcoding.com, jpirko@redhat.com
Subject: Re: [PATCH net-next v1 2/2] netpoll: avoid reference leaks
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAG88wWZ9GiqoOscqG4-ePOWo8bXgSTAQ6=6-tZPahMcxOvQMLg@mail.gmail.com>
References: <f98ccbfee35a7ab7f9499ede9b34e6b1120d88f1.1404172155.git.decot@googlers.com>
	<20140707.193505.345276817146527821.davem@davemloft.net>
	<CAG88wWZ9GiqoOscqG4-ePOWo8bXgSTAQ6=6-tZPahMcxOvQMLg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 14:17:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>
Date: Tue, 8 Jul 2014 12:35:14 -0700

> Thanks for the feedback. This patch results from manual inspection of
> the code. I agree my commit description is abusive: in the case of
> bonding, I think everything is fine, there should be no ref leak,
> cleanup paths seem clean.
> 
> My point was to make things more predictable: ndo_netpoll_cleanup
> called anyways to acknowledge actual loss of a ref to npinfo,
> irrespective of whether it's the last ref or not. Without this patch,
> calling ndo_netpoll_cleanup would depend on some timing behavior, hard
> to predict, and users of the API have better be careful to reclaim the
> refs manually anyways: as a consequence, not sure this callback is
> actually required in its current inception.

You've increased my confusion rather than decreased it.

You fail to address the core issue in my feedback:

	Whoever drops the refcount to zero must be the one to invoke
	the cleanup function.

Please address this concisely, and directly.
