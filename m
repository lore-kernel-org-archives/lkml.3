Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaFQBUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 21:20:55 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37026 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaFQBUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 21:20:53 -0400
Date: Mon, 16 Jun 2014 18:20:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bart Van Assche <bvanassche@acm.org>
cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spin_lock_*(): Always evaluate second argument
In-Reply-To: <539ED993.80807@acm.org>
Message-ID: <alpine.DEB.2.02.1406161820380.21018@chino.kir.corp.google.com>
References: <539ED993.80807@acm.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Bart Van Assche wrote:

> Evaluating a macro argument only if certain configuration options
> have been selected is confusing and error-prone. Hence always
> evaluate the second argument of spin_lock_nested() and
> spin_lock_nest_lock().
> 
> This patch has the intentional side effect that it avoids that the
> following warning is reported for netif_addr_lock_nested() when
> building with CONFIG_DEBUG_LOCK_ALLOC=n and with W=1:
> 
> include/linux/netdevice.h: In function 'netif_addr_lock_nested':
> include/linux/netdevice.h:2865:6: warning: variable 'subclass' set but not used [-Wunused-but-set-variable]
>   int subclass = SINGLE_DEPTH_NESTING;
>       ^
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: David S. Miller <davem@davemloft.net>

Acked-by: David Rientjes <rientjes@google.com>
