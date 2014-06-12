Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbaFLD3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:29:31 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:47182 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755404AbaFLD33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:29:29 -0400
X-IronPort-AV: E=Sophos;i="5.00,693,1396972800"; 
   d="scan'208";a="31792490"
Message-ID: <53991FB4.2060001@cn.fujitsu.com>
Date: Thu, 12 Jun 2014 11:34:12 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch V4 02/10] rtmutex: Simplify rtmutex_slowtrylock()
References: <20140611182944.108526809@linutronix.de> <20140611183853.029651737@linutronix.de>
In-Reply-To: <20140611183853.029651737@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 02:44 AM, Thomas Gleixner wrote:
> Oleg noticed that rtmutex_slowtrylock() has a pointless check for
> rt_mutex_owner(lock) != current.
> 
> To avoid calling try_to_take_rtmutex() we really want to check whether
> the lock has an owner at all or whether the trylock failed because the
> owner is NULL, but the RT_MUTEX_HAS_WAITERS bit is set. This covers
> the lock is owned by caller situation as well.
> 
> We can actually do this check lockless. trylock is taking a chance
> whether we take lock->wait_lock to do the check or not.
> 
> Add comments to the function while at it.
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks,
Lai
