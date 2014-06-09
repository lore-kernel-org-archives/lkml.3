Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431AbaFILHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:07:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:44266 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaFILHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:07:03 -0400
Date: Mon, 9 Jun 2014 13:06:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
cc: viresh.kumar@linaro.org, paul.gortmaker@windriver.com,
        peterz@infradead.org, stuart.w.hayes@gmail.com,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimers: conditionally lock/unlock spinlock in
 hrtimer_get_next_event
In-Reply-To: <1402305825-3015-1-git-send-email-stfomichev@yandex-team.ru>
Message-ID: <alpine.DEB.2.10.1406091304140.3830@nanos>
References: <1402305825-3015-1-git-send-email-stfomichev@yandex-team.ru>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Stanislav Fomichev wrote:

> In hrtimer_get_next_event we unconditionally lock/unlock spinlock, even if it's
> not required (hrtimer_hres_active() != 0). This patch moves
> locking/unlocking and mindelta range check inside the if clause,
> so we don't execute unnecessary operations.

What's wrong with simply doing:

       if (!hrtimer_hres_active())
       	  return mindelta;

That saves and indentation level and makes the code more
readable. Also the lockless check wants a comment why it is correct.

Thanks,

	tglx
