Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab3LLA6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:58:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60824 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3LLA6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:58:54 -0500
Date: Wed, 11 Dec 2013 19:58:52 -0500 (EST)
Message-Id: <20131211.195852.780453472852893891.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jasowang@redhat.com,
        wuzhy@linux.vnet.ibm.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131212114959.b08ea67fe5624ed6fb392c52@canb.auug.org.au>
References: <20131212111539.cff1b2efe934c5cd7abbb822@canb.auug.org.au>
	<20131211.193639.2058525533631918382.davem@davemloft.net>
	<20131212114959.b08ea67fe5624ed6fb392c52@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 16:58:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 12 Dec 2013 11:49:59 +1100

> Hi Dave,
> 
> On Wed, 11 Dec 2013 19:36:39 -0500 (EST) David Miller <davem@davemloft.net> wrote:
>>
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Thu, 12 Dec 2013 11:15:39 +1100
>> 
>> > Today's linux-next merge of the net-next tree got a conflict in
>> > drivers/net/macvtap.c between commit ce232ce01d61 ("macvtap: signal
>> > truncated packets") from the net tree and commit 55ec8e25cd97 ("macvtap:
>> > remove unused parameter in macvtap_do_read()") from the net-next tree.
>> > 
>> > I fixed it up (see below) and can carry the fix as necessary (no action
>> > is required).
>> 
>> The net-next commit in question was reverted last night.
> 
> Actually, the only relevant revert in the net-next tree I fetched this
> morning is commit de2aa4760b45 (Revert "macvtap: remove useless codes in
> macvtap_aio_read() and macvtap_recvmsg()") which reverts 41e4af69a598,
> not the commit mentioned above.  Unless you haven't pushed out the
> net-next tree with a later revert ...

Indeed, I was confusing those two commits.  Ok I should probably
revert that one too.

I'll go ahead and do that now, because it's the most straightforward
way to avoid this merge conflict.

Thanks!
