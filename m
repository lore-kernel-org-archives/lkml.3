Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3BILvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 06:51:52 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:32829 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab3BILvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 06:51:50 -0500
Date: Sat, 9 Feb 2013 11:51:49 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Martin Sustrik <sustrik@250bpm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
Message-ID: <20130209115149.GA15636@dcvr.yhbt.net>
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com>
 <20130207144433.527ef024.akpm@linux-foundation.org>
 <5114F2D8.5020300@250bpm.com>
 <20130208222107.GA4762@dcvr.yhbt.net>
 <5115B720.2080207@250bpm.com>
 <20130209035431.GA28448@dcvr.yhbt.net>
 <5115FC6A.8000603@250bpm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5115FC6A.8000603@250bpm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Sustrik <sustrik@250bpm.com> wrote:
> On 09/02/13 04:54, Eric Wong wrote:
> >>>Using one eventfd per userspace socket still seems a bit wasteful.
> >>
> >>Wasteful in what sense? Occupying a slot in file descriptor table?
> >>That's the price for having the socket uniquely identified by the
> >>fd.
> >
> >Yes.  I realize eventfd is small, but I don't think eventfd is needed
> >at all, here.  Just one pipe.
> 
> Ah. Got you! You mean not to change the kernel, just use pipe for
> the purpose.
> 
> However, the convoluted pipe-style design is the problem I am trying
> to solve rather than the solution. It leads to convoluted APIs with
> convoluted semantics as described in the article. I've been using
> that kind of design for past 8 years and every time I have to deal
> with it I swear that one day I will implement a proper in-kernel
> solution to get rid of the hack.
> 
> And now I have finally done so.

Yes, your eventfd change is probably the best way if you want/need
to only watch a subset of your sockets, especially if you want
poll/select to be an option.

