Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3HZWBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:01:52 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:34690 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3HZWBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:01:50 -0400
MIME-Version: 1.0
In-Reply-To: <1377269106-26468-1-git-send-email-zwu.kernel@gmail.com>
References: <1377269106-26468-1-git-send-email-zwu.kernel@gmail.com>
Date: Mon, 26 Aug 2013 15:01:49 -0700
Message-ID: <CANN689ET-2q_7WY+4HZjMqQEmLpOQyWOrOzRnP3ADc8TAzoEXw@mail.gmail.com>
Subject: Re: [PATCH] rbtree: Add some necessary condition checks
From: Michel Lespinasse <walken@google.com>
To: zwu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 7:45 AM,  <zwu.kernel@gmail.com> wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  include/linux/rbtree_augmented.h | 3 ++-
>  lib/rbtree.c                     | 5 +++--
>  2 files changed, 5 insertions(+), 3 deletions(-)

So, you are saying that the checks are necessary, but you are not saying why.

The way I see it, the checks are *not* necessary, because the rbtree
invariants guarantee them to be true. The only way for the checks to
fail would be if people directly manipulate the rbtrees without going
through the proper APIs, and if they do that then I think they're on
their own. So to me, I think it's the same situation as dereferencing
a pointer without checking if it's NULL, because you know it should
never be NULL - which in my eyes is perfectly acceptable.

If you really feel this is a problem, you should explain why. I would
also prefer if any checks you add could be limited to debug builds.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
