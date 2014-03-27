Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaC0IxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:53:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbaC0IxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:53:03 -0400
Message-ID: <5333E6E3.3020907@redhat.com>
Date: Thu, 27 Mar 2014 09:52:51 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@stressinduktion.org, tytso@mit.edu
Subject: Re: [PATCH v2] random32: avoid attempt to late reseed if in the middle
 of seeding
References: <1395900095-15254-1-git-send-email-sasha.levin@oracle.com> <1395900095-15254-2-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1395900095-15254-2-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 07:01 AM, Sasha Levin wrote:
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

Looks better now, thanks!

Fixes: 4af712e8df99 ("random32: add prandom_reseed_late() and call when nonblocking pool becomes initialized")
Acked-by: Daniel Borkmann <dborkman@redhat.com>
