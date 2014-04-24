Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaDXUs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:48:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34389 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaDXUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:48:23 -0400
Date: Thu, 24 Apr 2014 16:48:20 -0400 (EDT)
Message-Id: <20140424.164820.1543648508330465096.davem@davemloft.net>
To: vgoyal@redhat.com
Cc: luto@amacapital.net, tj@kernel.org, dwalsh@redhat.com,
        linux-kernel@vger.kernel.org, lpoetter@redhat.com, ssorce@redhat.com,
        cgroups@vger.kernel.org, kay@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140424203427.GC19091@redhat.com>
References: <20140423164537.GD24651@redhat.com>
	<20140423.132955.671992126955940387.davem@davemloft.net>
	<20140424203427.GC19091@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Apr 2014 13:48:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 24 Apr 2014 16:34:27 -0400

> By open() time you mean at socket() time or at connect() time?

I mean at all of the places at which init_peercred() occurs.

> You also mentioned that you want SO_PEERCGROUP and SO_PASSCGROUP as
> pairs like SO_PEERCRED and SO_PASSCRED.  But to me, SO_PEERCRED and
> SO_PASSCRED are not *exact* pairs and are little different in their
> semantics.  SO_PEERCRED gives us client creds at connect() time
> while SO_PASSCRED client's real creds at sendmsg() time. SO_PASSCRED
> does not store client's credential's at connect() time for datagram
> sockets.

Then you haven't been following the discussion.

The client's credentials at sendmsg()/write() time are "DO NOT CARE".

You cannot even guarentee the semantics in the logging example if
you ask for these "client identity at sendmsg() time" semantics.

What if the event occured when the client was in cgroup1, and the
log message goes out after it has been moved into cgroup2?

That is just proof that this whole idea is fundamentally flawed.

You guys need to come up with something else to achieve your goals,
this isn't it.
