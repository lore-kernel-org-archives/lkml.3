Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaE0TYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:24:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46047 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaE0TYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:24:17 -0400
Date: Tue, 27 May 2014 15:24:14 -0400 (EDT)
Message-Id: <20140527.152414.1304343647733553805.davem@davemloft.net>
To: amirv@mellanox.com
Cc: ogerlitz@mellanox.com, netdev@vger.kernel.org, yevgenyp@mellanox.com,
        yuvala@mellanox.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V6 1/2] cpumask: Utility function to set n'th
 cpu - local cpu first
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401029247-15196-2-git-send-email-amirv@mellanox.com>
References: <1401029247-15196-1-git-send-email-amirv@mellanox.com>
	<1401029247-15196-2-git-send-email-amirv@mellanox.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 May 2014 12:24:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Vadai <amirv@mellanox.com>
Date: Sun, 25 May 2014 17:47:26 +0300

> This function sets the n'th cpu - local cpu's first.
> For example: in a 16 cores server with even cpu's local, will get the
> following values:
> cpumask_set_cpu_local_first(0, numa, cpumask) => cpu 0 is set
> cpumask_set_cpu_local_first(1, numa, cpumask) => cpu 2 is set
> ...
> cpumask_set_cpu_local_first(7, numa, cpumask) => cpu 14 is set
> cpumask_set_cpu_local_first(8, numa, cpumask) => cpu 1 is set
> cpumask_set_cpu_local_first(9, numa, cpumask) => cpu 3 is set
> ...
> cpumask_set_cpu_local_first(15, numa, cpumask) => cpu 15 is set
> 
> Curently this function will be used by multi queue networking devices to
> calculate the irq affinity mask, such that as many local cpu's as
> possible will be utilized to handle the mq device irq's.
> 
> Signed-off-by: Amir Vadai <amirv@mellanox.com>

I would like someone who cares about these cpumask interfaces to provide
a review.
