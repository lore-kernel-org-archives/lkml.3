Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbaJVBjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:39:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54066 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJVBjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:39:10 -0400
Date: Tue, 21 Oct 2014 21:39:08 -0400 (EDT)
Message-Id: <20141021.213908.1088381802543942481.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: a.ryabinin@samsung.com, pablo@netfilter.org, mschmidt@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netlink: don't copy over empty attribute data
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413924669-26732-1-git-send-email-sasha.levin@oracle.com>
References: <1413924669-26732-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Oct 2014 18:39:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Tue, 21 Oct 2014 16:51:09 -0400

> netlink uses empty data to seperate different levels. However, we still
> try to copy that data from a NULL ptr using memcpy, which is an undefined
> behaviour.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

This isn't a POSIX C library, this it the Linux kernel, and as such
we can make sure none of our memcpy() implementations try to access
any bytes if the given length is NULL.

And to be quite honest, there is no benefit whatsoever nor even the
possibility of using that "undefined behavior" flexibility to do
anthing. This is because every memcpy() implementation must be sure
not to access past the end of either source or destination buffer.

And the one and only way to do that is to respect the length.

I'm not applying this, because the basis for which this is claimed
to be a bug fix is quite bogus in my opinion.

Sorry.
