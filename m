Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3LSBG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:06:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36213 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3LSBG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:06:57 -0500
Message-ID: <52B246AC.1090107@infradead.org>
Date: Wed, 18 Dec 2013 17:06:52 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Matias Bjorling <m@bjorling.me>, axboe@kernel.dk
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] null_blk: documentation
References: <1387370504-30853-1-git-send-email-m@bjorling.me> <1387370504-30853-2-git-send-email-m@bjorling.me>
In-Reply-To: <1387370504-30853-2-git-send-email-m@bjorling.me>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/13 04:41, Matias Bjorling wrote:
> Add description of module and its parameters.
> 
> Signed-off-by: Matias Bjorling <m@bjorling.me>
> ---
>  Documentation/block/null_blk.txt | 71 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/block/null_blk.txt
> 
> diff --git a/Documentation/block/null_blk.txt b/Documentation/block/null_blk.txt
> new file mode 100644
> index 0000000..9e1b047
> --- /dev/null
> +++ b/Documentation/block/null_blk.txt
> @@ -0,0 +1,71 @@
> +Null block device driver
> +================================================================================
> +
> +I. Overview
> +
> +The null block device (/dev/nullb*) is used for benchmarking the various
> +block-layer implementations. It emulates a block device of X gigabytes in size.
> +The following instances are possible:
> +
> +  Single-queue block-layer
> +    - Request-based.
> +    - Single submission queue per device.
> +    - Implements IO scheduling algorithms (CFQ, Deadline, noop).
> +  Multi-queue block-layer
> +    - Request-based.
> +    - Configurable submission queues per device.
> +  No block-layer (Known as bio-based)
> +    - Bio-based. IO requests are submitted directly to the device driver.
> +    - Directly accepts bio data structure and returns them.
> +
> +All of them has a completion queue for each core in the system.

               have

The text sometimes uses "core" vs. "socket" vs. "cpu(s)".
Did you double-check all of these uses?  Thanks.


> +
> +II. Module parameters applicable for all instances:
> +
> +queue_mode=[0-2]: Default: 2-Multi-queue
> +  Selects which block-layer the module should instantiate with.
> +
> +  0: Bio-based.
> +  1: Single-queue.
> +  2: Multi-queue.
> +
> +home_node=[0--nr_nodes]: Default: NUMA_NO_NODE
> +  Selects what socket the data structures is allocated from.

                                             are

> +
> +gb=[Size in GB]: Default: 250GB
> +  The size of the device reported to the system.
> +
> +bs=[Block size (in bytes)]: Default: 512 bytes
> +  The block size reported to the system.
> +
> +nr_devices=[Num. devices]: Default: 2

               Number

> +  Number of block devices instantiated. They are instantiated as /dev/nullb0,
> +  etc.
> +
> +irq_mode=[0-2]: Default: Soft-irq

                   Default: 1-Soft-irq

> +  The completion mode used for completing IOs to the block-layer.
> +
> +  0: None.
> +  1: Soft-irq. Uses ipi to complete IOs across sockets. Simulates the overhead

                       IPI

> +     when IOs are issued from another socket than the home the device is
> +     connected to.
> +  2: Timer: Waits a specific period (completion_nsec) for each IO before
> +     completion.
> +
> +completion_nsec=[Num. ns]: Default: 10.000ns

                    Number

> +  Combined with irq_mode=2 (timer). The time each completion event must wait.
> +
> +submit_queues=[0..nr_cpus]:
> +  The number of submission queues attached to the device driver. If unset, it
> +  defaults to 1 on single-queue and bio-based instances. For multi-queue,
> +  its ignored when use_per_node_hctx module parameter is 1.

     it is

> +
> +hw_queue_depth=[0..qdepth]: Defaults: 64

                               Default:

> +  The hardware queue depth of the device.
> +
> +III: Multi-queue specific parameters
> +
> +use_per_node_hctx=[0/1]: Defaults: 1

                            Default:

> +  If 1, the multi-queue block layer is instantiated with a hardware dispatch
> +  queue for each CPU node in the system. If 0, it is instantiated with the
> +  number of queues defined in the submit_queues parameter.
> 


-- 
~Randy
