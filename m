Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbaGOKDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:03:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:46989 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182AbaGOKDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:03:32 -0400
Date: Tue, 15 Jul 2014 12:03:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ley Foon Tan <lftan@altera.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 21/29] nios2: Futex operations
In-Reply-To: <1405413956-2772-22-git-send-email-lftan@altera.com>
Message-ID: <alpine.DEB.2.10.1407151201170.24854@nanos>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-22-git-send-email-lftan@altera.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Ley Foon Tan wrote:
 +static inline int atomic_futex_op_xchg_set(int oparg, u32 __user *uaddr,
> +					   int *oldval)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	local_irq_save(flags);
> +
> +	ret = get_user(*oldval, uaddr);
> +	if (!ret)
> +		ret = put_user(oparg, uaddr);

This is wrong as it gets. get_user() might fault and sleep.

You need a proper implementation, which handles fault exceptions.

Thanks,

	tglx
