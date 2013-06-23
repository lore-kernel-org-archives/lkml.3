Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3FWPI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 11:08:58 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63211 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3FWPI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 11:08:56 -0400
Message-ID: <51C70F82.4030101@cogentembedded.com>
Date: Sun, 23 Jun 2013 19:08:50 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 07/45] CPU hotplug: Expose the new debug config option
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com> <20130623133928.19094.8259.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130623133928.19094.8259.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-06-2013 17:39, Srivatsa S. Bhat wrote:

> Now that we have all the pieces of the CPU hotplug debug infrastructure
> in place, expose the feature by growing a new Kconfig option,
> CONFIG_DEBUG_HOTPLUG_CPU.

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>
> Cc: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Michel Lespinasse <walken@google.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---

>   lib/Kconfig.debug |    9 +++++++++
>   1 file changed, 9 insertions(+)

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 566cf2b..6be1e72 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -512,6 +512,15 @@ config DEBUG_PREEMPT
>   	  if kernel code uses it in a preemption-unsafe way. Also, the kernel
>   	  will detect preemption count underflows.
>
> +config DEBUG_HOTPLUG_CPU
> +	bool "Debug CPU hotplug"
> +	depends on HOTPLUG_CPU
> +	default n

     It's the default default, no need to specify it.

WBR, Sergei

