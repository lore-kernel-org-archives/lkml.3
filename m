Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980Ab3CHXyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:54:12 -0500
Received: from [140.211.169.12] ([140.211.169.12]:51429 "EHLO
	mail.linuxfoundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754610Ab3CHXyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:54:11 -0500
Date: Fri, 8 Mar 2013 15:54:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epoll: trim epitem by one cache line on x86_64
Message-Id: <20130308155410.3c63f24ee28e6532006cb0d4@linux-foundation.org>
In-Reply-To: <20130307103240.GA24132@dcvr.yhbt.net>
References: <20130304112941.GA16284@dcvr.yhbt.net>
	<20130306143741.d5e56f13c94d2d6b2c1ea449@linux-foundation.org>
	<20130307103240.GA24132@dcvr.yhbt.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Mar 2013 10:32:40 +0000 Eric Wong <normalperson@yhbt.net> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> > It's going to be hard to maintain this - someone will change something
> > sometime and break it.  I suppose we could add a runtime check if we
> > cared enough.  Adding a big fat comment to struct epitem might help.
> 
> Thanks for looking at this patch.  I'll send a patch with a comment
> about keeping epitem size in check.  Also, would adding (with comments):
> 
> 	BUILD_BUG_ON(sizeof(struct epitem) > 128);
> 
> ...be too heavy-handed?  I used that in my testing.  I'll check for:
> sizeof(void *) <= 8 too; in case 128-bit machines appear...

I guess such a check might avoid accidents in the future.  If it
becomes a problem, we can always delete it.

