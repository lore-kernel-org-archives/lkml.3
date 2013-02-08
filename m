Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405Ab3BHWVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:21:09 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:55543 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758163Ab3BHWVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:21:08 -0500
Date: Fri, 8 Feb 2013 22:21:07 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Martin Sustrik <sustrik@250bpm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
Message-ID: <20130208222107.GA4762@dcvr.yhbt.net>
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com>
 <20130207144433.527ef024.akpm@linux-foundation.org>
 <5114F2D8.5020300@250bpm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5114F2D8.5020300@250bpm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Sustrik <sustrik@250bpm.com> wrote:
> On 07/02/13 23:44, Andrew Morton wrote:
> >That's a nice changelog but it omitted a critical thing: why do you
> >think the kernel needs this feature?  What's the value and use case for
> >being able to poll these descriptors?
> 
> To address the question, I've written down detailed description of
> the challenges of the network protocol development in user space and
> how the proposed feature addresses the problems.
> 
> It's too long to fit into ChangeLog, but it may be worth reading
> when trying to judge the merit of the patch.
> 
> It can be found here: http://www.250bpm.com/blog:16

Using one eventfd per userspace socket still seems a bit wasteful.

Couldn't you use a single pipe for all sockets and write the efd_mask to
the pipe for each socket?

A read from the pipe would behave like epoll_wait.

You might need to use one-shot semantics; but that's probably
the easiest thing in multithreaded apps anyways.
