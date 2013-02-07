Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945925Ab3BGWog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:44:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422729Ab3BGWof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:44:35 -0500
Date: Thu, 7 Feb 2013 14:44:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Sustrik <sustrik@250bpm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
Message-Id: <20130207144433.527ef024.akpm@linux-foundation.org>
In-Reply-To: <1360219292-19754-1-git-send-email-sustrik@250bpm.com>
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Feb 2013 07:41:32 +0100
Martin Sustrik <sustrik@250bpm.com> wrote:

> When implementing network protocols in user space, one has to implement
> fake user-space file descriptors to represent the sockets for the protocol.
> 
> While all the BSD socket API functionality for such descriptors may be faked as
> well (myproto_send(), myproto_recv() etc.) this approach doesn't work for
> polling  (select, poll, epoll). For polling, real system-level file descriptor
> is needed.

That's a nice changelog but it omitted a critical thing: why do you
think the kernel needs this feature?  What's the value and use case for
being able to poll these descriptors?

So please update the changelog and then cc netdev@vger.kernel.org on
the patch - the netdev people are probably best-situated to comment on
the proposal.

