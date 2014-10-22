Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaJVGPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:15:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55393 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaJVGPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:15:14 -0400
Date: Wed, 22 Oct 2014 02:15:08 -0400 (EDT)
Message-Id: <20141022.021508.2011745433893496421.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: a.ryabinin@samsung.com, pablo@netfilter.org, mschmidt@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netlink: don't copy over empty attribute data
From: David Miller <davem@davemloft.net>
In-Reply-To: <54471438.1040907@oracle.com>
References: <1413924669-26732-1-git-send-email-sasha.levin@oracle.com>
	<20141021.213908.1088381802543942481.davem@davemloft.net>
	<54471438.1040907@oracle.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Oct 2014 23:15:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Tue, 21 Oct 2014 22:19:36 -0400

> On 10/21/2014 09:39 PM, David Miller wrote:
>> From: Sasha Levin <sasha.levin@oracle.com>
>> Date: Tue, 21 Oct 2014 16:51:09 -0400
>> 
>>> > netlink uses empty data to seperate different levels. However, we still
>>> > try to copy that data from a NULL ptr using memcpy, which is an undefined
>>> > behaviour.
>>> > 
>>> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> This isn't a POSIX C library, this it the Linux kernel, and as such
>> we can make sure none of our memcpy() implementations try to access
>> any bytes if the given length is NULL.
> 
> We can make *our* implementations work around that undefined behaviour if we
> want, but right now our implementations is to call GCC's builtin memcpy(),
> which follows the standards and doesn't allow you to call it with NULL 'from'
> ptr.
> 
> The fact that it doesn't die and behaves properly is just "luck".

If GCC's internal memcpy() starts accessing past 'len', I'm going
to report the bug rather than code around it.

That causes a page fault, you _can't_ do it.
