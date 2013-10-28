Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3J1FoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:44:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab3J1FoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:44:17 -0400
Message-ID: <526DF9A4.70709@redhat.com>
Date: Mon, 28 Oct 2013 13:44:04 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [virtio-net] BUG: sleeping function called from invalid context
 at kernel/mutex.c:616
References: <20131020023418.GA6737@localhost> <526638D4.1030403@redhat.com> <20131023232033.GA7404@localhost>
In-Reply-To: <20131023232033.GA7404@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 07:20 AM, Fengguang Wu wrote:
> Yes it reduces the sleeping function bug:
>
> /kernel/x86_64-lkp-CONFIG_SCSI_DEBUG/7c4ed2767afb813493b0a8fb18d666cd44550963
>
> +------------------------------------------------------------------------------------+-----------+--------------+--------------+
> |                                                                                    | v3.12-rc3 | 3ab098df35f8 | 7c4ed2767afb |
> +------------------------------------------------------------------------------------+-----------+--------------+--------------+
> | good_boots                                                                         | 30        | 0            | 93           |
> | has_kernel_error_warning                                                           | 0         | 20           | 7            |
> | BUG:sleeping_function_called_from_invalid_context_at_kernel/mutex.c                | 0         | 20           |              |
> | INFO:rcu_sched_self-detected_stall_on_CPU(t=jiffies_g=c=q=)                        | 0         | 0            | 1            |
> | INFO:task_blocked_for_more_than_seconds                                            | 0         | 0            | 2            |
> | INFO:NMI_handler(arch_trigger_all_cpu_backtrace_handler)took_too_long_to_run:msecs | 0         | 0            | 1            |
> | Kernel_panic-not_syncing:hung_task:blocked_tasks                                   | 0         | 0            | 1            |
> | BUG:kernel_test_crashed                                                            | 0         | 0            | 3            |
> | BUG:kernel_test_hang                                                               | 0         | 0            | 1            |
> +------------------------------------------------------------------------------------+-----------+--------------+--------------+
>
> However I'll need to increase tests on v3.12-rc3 to make sure it's not
> the patch that added the other error messages.
>
> Thanks,
> Fengguang

Thanks, any more update on the result of v3.12-rc3 for this?

