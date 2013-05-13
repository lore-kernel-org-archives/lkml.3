Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3EMXqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:46:24 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39093 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3EMXqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:46:23 -0400
Date: Mon, 13 May 2013 17:42:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Robert Love <rlove@google.com>
Cc: Shankar Brahadeeswaran <shankoo77@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        devel <devel@driverdev.osuosl.org>, Hugh Dickins <hughd@google.com>,
        Anjana V Kumar <anjanavk12@gmail.com>, Dad <akpm@linux-foundation.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [PATCH -next] ashmem: Fix ashmem_shrink deadlock.
Message-ID: <20130513214216.GA23743@kroah.com>
References: <1367416573-5430-1-git-send-email-rlove@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367416573-5430-1-git-send-email-rlove@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 09:56:13AM -0400, Robert Love wrote:
> Don't acquire ashmem_mutex in ashmem_shrink if we've somehow recursed into the
> shrinker code from within ashmem. Just bail out, avoiding a deadlock. This is
> fine, as ashmem cache pruning is advisory anyhow.
> 
> Signed-off-by: Robert Love <rlove@google.com>
> ---
>  drivers/staging/android/ashmem.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Based on Andrew's review comments, I'll drop this from my queue and wait
for a "better" fix for this.

thanks,

greg k-h
