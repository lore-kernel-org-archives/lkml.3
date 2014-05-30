Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbaE3Qsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:48:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:11479 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933923AbaE3Qsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:48:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,942,1392192000"; 
   d="scan'208";a="540121065"
Date: Fri, 30 May 2014 10:48:27 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4] NVMe: basic conversion to blk-mq
In-Reply-To: <1401400285-25003-2-git-send-email-m@bjorling.me>
Message-ID: <alpine.LRH.2.03.1405301027350.11244@AMR>
References: <1401400285-25003-1-git-send-email-m@bjorling.me> <1401400285-25003-2-git-send-email-m@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1450090779-1401468511=:11244"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1450090779-1401468511=:11244
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 29 May 2014, Matias Bjørling wrote:
> This converts the current NVMe driver to utilize the blk-mq layer.

I'm pretty darn sure this new nvme_remove can cause a process
with an open reference to use queues after they're freed in the
nvme_submit_sync_command path, maybe even the admin tags too.

> @@ -2802,7 +2574,7 @@ static void nvme_remove(struct pci_dev *pdev)
> 	nvme_dev_remove(dev);
> 	nvme_dev_shutdown(dev);
> 	nvme_free_queues(dev, 0);
> -	rcu_barrier();
> +	nvme_free_admin_tags(dev);
> 	nvme_release_instance(dev);
> 	nvme_release_prp_pools(dev);
> 	kref_put(&dev->kref, nvme_free_dev);
--8323328-1450090779-1401468511=:11244--
