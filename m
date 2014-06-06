Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaFFRNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:13:12 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:36634 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaFFRNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:13:10 -0400
Message-ID: <1402074788.6680.50.camel@j-VirtualBox>
Subject: Re: [PATCH 1/2] locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, mpatocka@redhat.com,
        torvalds@linux-foundation.org, waiman.long@hp.com,
        jejb@parisc-linux.org, paulmck@linux.vnet.ibm.com,
        dave.anglin@bell.net, aswin@hp.com, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Date: Fri, 06 Jun 2014 10:13:08 -0700
In-Reply-To: <1402070140-15090-2-git-send-email-davidlohr@hp.com>
References: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
	 <1402070140-15090-2-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 08:55 -0700, Davidlohr Bueso wrote:
> Just like with mutexes (CONFIG_MUTEX_SPIN_ON_OWNER),
> encapsulate the dependencies for rwsem optimistic spinning.
> No logical changes here as it continues to depend on both
> SMP and the XADD algorithm variant.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  include/linux/rwsem.h  | 4 ++--
>  kernel/Kconfig.locks   | 4 ++++
>  kernel/locking/rwsem.c | 2 +-
>  3 files changed, 7 insertions(+), 3 deletions(-)

Do we also want to add an #ifdef CONFIG_RWSEM_SPIN_ON_OWNER in
__init_rwsem() and in the optimistic spinning functions for rwsem-xadd?


Besides that:

Acked-by: Jason Low <jason.low2@hp.com>


