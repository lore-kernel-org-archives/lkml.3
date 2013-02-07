Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab3BGK3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:29:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28224 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab3BGK31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:29:27 -0500
Date: Thu, 7 Feb 2013 10:28:43 +0000
From: Jamie Iles <jamie.iles@oracle.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@kernel.org, peterz@infradead.org, jamie.iles@oracle.com,
        penberg@kernel.org, acme@ghostprotocols.net, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] liblockdep: support using LD_PRELOAD
Message-ID: <20130207102843.GG17781@cedar>
References: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
 <1360188694-25077-10-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360188694-25077-10-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

On Wed, Feb 06, 2013 at 05:11:32PM -0500, Sasha Levin wrote:
> This allows lockdep to be used without being compiled in the original program.
> 
> Usage is quite simple:
> 
> 	LD_PRELOAD=/path/to/liblockdep.so /path/to/my/program
> 
> And magically, you'll have lockdep in your program!
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
> diff --git a/tools/lib/lockdep/preload.c b/tools/lib/lockdep/preload.c
> new file mode 100644
> index 0000000..0f71c23
> --- /dev/null
> +++ b/tools/lib/lockdep/preload.c
...
> +int pthread_rwlock_init(pthread_rwlock_t *rwlock,
> +			const pthread_rwlockattr_t *attr)
> +{
> +	if (ll_pthread_rwlock_init == NULL)
> +		init_preload();

Why is this one special, doesn't init_preload being a constructor make 
this redundant?

Jamie
