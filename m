Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaI3Rmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:42:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:28351 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaI3Rmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,628,1406617200"; 
   d="scan'208";a="611038799"
Date: Tue, 30 Sep 2014 11:42:34 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, tom.leiming@gmail.com, hch@infradead.org,
        rlnelson@google.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v13] NVMe: Convert to blk-mq
In-Reply-To: <1412098195-30133-2-git-send-email-m@bjorling.me>
Message-ID: <alpine.LRH.2.03.1409301134580.4688@AMR>
References: <1412098195-30133-1-git-send-email-m@bjorling.me> <1412098195-30133-2-git-send-email-m@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1747668169-1412098955=:4688"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1747668169-1412098955=:4688
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 30 Sep 2014, Matias Bjørling wrote:
> @@ -1967,27 +1801,30 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
> {
...
> -	ns->queue->queue_flags = QUEUE_FLAG_DEFAULT;
> +	queue_flag_set_unlocked(QUEUE_FLAG_DEFAULT, ns->queue);

Instead of the above, you want

+	ns->queue->queue_flags |= QUEUE_FLAG_DEFAULT;

I only caught it because of the fun dm-mpath attempt with nvme and
blk-mq. Or maybe we don't want to include "QUEUE_FLAG_STACKABLE" right
now (part of the default flags) because it will kernel crash if you're
using dm-multipath with a blk-mq driver today.

Otherwise, looks great!
--8323328-1747668169-1412098955=:4688--
