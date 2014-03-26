Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaCZRxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:53:07 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:33163 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaCZRxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:53:05 -0400
Date: Wed, 26 Mar 2014 18:53:02 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: davem@davemloft.net, dborkman@redhat.com, tytso@mit.edu,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH] random32: avoid attempt to late reseed if in the middle of seeding
Message-ID: <20140326175302.GA30181@order.stressinduktion.org>
Mail-Followup-To: Sasha Levin <sasha.levin@oracle.com>, davem@davemloft.net,
	dborkman@redhat.com, tytso@mit.edu, linux-kernel@vger.kernel.org,
	eric.dumazet@gmail.com
References: <1395853958-5083-1-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1395853958-5083-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 01:12:38PM -0400, Sasha Levin wrote:
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

Ohh, I overlooked that. Thanks for fixing this, looks good.

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

