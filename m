Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbaE3PvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:51:16 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:55868 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933502AbaE3PvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:51:09 -0400
Date: Fri, 30 May 2014 11:51:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 12/12] block, bfq: boost the throughput
 with random I/O on NCQ-capable HDDs
Message-ID: <20140530155105.GF24871@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-13-git-send-email-paolo.valente@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401354343-5527-13-git-send-email-paolo.valente@unimore.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:05:43AM +0200, Paolo Valente wrote:
> This patch is basically the counterpart of patch 13 for NCQ-capable
> rotational devices. Exactly as patch 13 does on flash-based devices
> and for any workload, this patch disables device idling on rotational
> devices, but only for random I/O. More precisely, idling is disabled
> only for constantly-seeky queues (see patch 7). In fact, only with
> these queues disabling idling boosts the throughput on NCQ-capable
> rotational devices.
> 
> To not break service guarantees, idling is disabled for NCQ-enabled
> rotational devices and constantly-seeky queues only when the same
> symmetry conditions as in patch 13, plus an additional one, hold. The
> additional condition is related to the fact that this patch disables
> idling only for constantly-seeky queues. In fact, should idling be

Wouldn't it make more sense to limit queue depth to one unless the
workload can clearly benefit from allowing higher queue depth?  And I
really think it'd bring more clarity if we just concentrate on
rotational devices.

Thanks.

-- 
tejun
