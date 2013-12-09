Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab3LIUwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:52:47 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:21689 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab3LIUwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:52:47 -0500
Message-ID: <52A62D9D.5080105@tilera.com>
Date: Mon, 9 Dec 2013 15:52:45 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
CC: <akpm@linuxfoundation.org>, <rostedt@goodmis.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 35/41] tile: Replace __get_cpu_var uses
References: <20131203233232.928771708@linux.com> <20131203233303.460840679@linux.com>
In-Reply-To: <20131203233303.460840679@linux.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/2013 6:33 PM, Christoph Lameter wrote:
> __get_cpu_var() is used for multiple purposes in the kernel source. One of
> them is address calculation via the form &__get_cpu_var(x).  This calculates
> the address for the instance of the percpu variable of the current processor
> based on an offset.
>
> [...]
>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Except for a comment typo:

>  /*
>   * Read the set of maskable interrupts.
> - * We avoid the preemption warning here via __this_cpu_ptr since even
> + * We avoid the preemption warning here via raw_cpu_ptr since even
>   * if irqs are already enabled, it's harmless to read the wrong cpu's
>   * enabled mask.
>   */
>  #define arch_local_irqs_enabled() \
> -	(*__this_cpu_ptr(&interrupts_enabled_mask))
> +	raw_cpu_read(interrupts_enabled_mask)

Should be raw_cpu_read() in the comment.

I assume you are planning to submit these through your own tree, not the arch trees?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

