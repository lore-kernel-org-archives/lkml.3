Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaC0GRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 02:17:45 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:34347 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaC0GRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 02:17:44 -0400
Date: Thu, 27 Mar 2014 07:17:42 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, dborkman@redhat.com
Subject: Re: [PATCH v2] random32: avoid attempt to late reseed if in the middle of seeding
Message-ID: <20140327061742.GM22086@order.stressinduktion.org>
Mail-Followup-To: Sasha Levin <sasha.levin@oracle.com>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
	dborkman@redhat.com
References: <1395900095-15254-1-git-send-email-sasha.levin@oracle.com> <1395900095-15254-2-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1395900095-15254-2-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 02:01:35AM -0400, Sasha Levin wrote:
> Commit 4af712e8df ("random32: add prandom_reseed_late() and call when
> nonblocking pool becomes initialized") has added a late reseed stage
> that happens as soon as the nonblocking pool is marked as initialized.
> 
> This fails in the case that the nonblocking pool gets initialized
> during __prandom_reseed()'s call to get_random_bytes(). In that case
> we'd double back into __prandom_reseed() in an attempt to do a late
> reseed - deadlocking on 'lock' early on in the boot process.
> 
> Instead, just avoid even waiting to do a reseed if a reseed is already
> occuring.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Thanks for fixing this!

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

