Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbaISLWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:22:21 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:30934 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaISLVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:21:41 -0400
Message-ID: <541C11C1.2060105@imgtec.com>
Date: Fri, 19 Sep 2014 12:21:37 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chuck Ebbert <cebbert.lkml@gmail.com>, Helge Deller <deller@gmx.de>
CC: <linux-kernel@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        "Aaron Tomlin" <atomlin@redhat.com>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] Fix end_of_stack() fn and location of stack canary for
 archs using STACK_GROWSUP
References: <20140916023736.49db964e@as>
In-Reply-To: <20140916023736.49db964e@as>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chuck,

On 16/09/14 08:37, Chuck Ebbert wrote:
>  static inline unsigned long *end_of_stack(struct task_struct *p)
>  {
> +#ifdef CONFIG_STACK_GROWSUP
> +	return (unsigned long *)((unsigned long)task_thread_info(p) + THREAD_SIZE) - 1;

Nit: this line should probably be wrapped to 80 columns.

Other than that, I've tested this on metag and can confirm that it fixes
the following BUG which you would otherwise get during boot with Aaron's
patches:

BUG: failure at kernel/sched/core.c:2664/schedule_debug()!
Kernel panic - not syncing: BUG!

Tested-by: James Hogan <james.hogan@imgtec.com> [metag]
Acked-by: James Hogan <james.hogan@imgtec.com>

Aaron: please can you try to get this patch applied before your patch
series.

Thanks
James
