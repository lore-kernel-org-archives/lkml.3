Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbaDWRaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:30:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50165 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaDWRaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:30:01 -0400
Date: Wed, 23 Apr 2014 13:29:55 -0400 (EDT)
Message-Id: <20140423.132955.671992126955940387.davem@davemloft.net>
To: vgoyal@redhat.com
Cc: luto@amacapital.net, tj@kernel.org, dwalsh@redhat.com,
        linux-kernel@vger.kernel.org, lpoetter@redhat.com, ssorce@redhat.com,
        cgroups@vger.kernel.org, kay@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140423164537.GD24651@redhat.com>
References: <20140416002010.GA5035@redhat.com>
	<CALCETrWzHYN3kKcmDTFDfGhZqE4u9+6XDtiOu5nncbK_7KKH0g@mail.gmail.com>
	<20140423164537.GD24651@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Apr 2014 10:30:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 23 Apr 2014 12:45:37 -0400

> On Tue, Apr 15, 2014 at 08:47:54PM -0700, Andy Lutomirski wrote:
> 
> [..]
>> Here's an attack against SO_PASSCGROUP, as you implemented it: connect
>> a socket and get someone else to write(2) to it.  This isn't very
>> hard.  Now you've impersonated.
> 
> If this is a problem then I think kernel requires fixing. Because kernel
> will apply all resource management policies based on the cgroup at write(2)
> time and not based on open() time.

Anyways, this is not even worth discussing.

We already agreed that the cgroup passed at write time with SO_PASSGROUP
enabled should be the socket creation time cgroup.

Just like SO_PASSCRED does.

The identity given is thus the one at open() time.
