Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaFPP5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:57:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:37605 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbaFPP5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:57:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,487,1400050800"; 
   d="scan'208";a="529285060"
Date: Mon, 16 Jun 2014 09:57:03 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, tom.leiming@gmail.com, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v8] NVMe: convert to blk-mq
In-Reply-To: <1402661396-19207-2-git-send-email-m@bjorling.me>
Message-ID: <alpine.LRH.2.03.1406160931400.4699@AMR>
References: <1402661396-19207-1-git-send-email-m@bjorling.me> <1402661396-19207-2-git-send-email-m@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-238916323-1402934225=:4699"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-238916323-1402934225=:4699
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 13 Jun 2014, Matias Bjørling wrote:
> This converts the current NVMe driver to utilize the blk-mq layer.

> static void nvme_reset_notify(struct pci_dev *pdev, bool prepare)
> {
> -       struct nvme_dev *dev = pci_get_drvdata(pdev);
> +	struct nvme_dev *dev = pci_get_drvdata(pdev);
>
> -       if (prepare)
> -               nvme_dev_shutdown(dev);
> -       else
> -               nvme_dev_resume(dev);
> +	spin_lock(&dev_list_lock);
> +	if (prepare)
> +		list_del_init(&dev->node);
> +	else
> +		list_add(&dev->node, &dev_list);
> +	spin_unlock(&dev_list_lock);
> }
> +		if (nvme_create_queue(dev->queues[i], i))
> 			break;
> }

The above change was just error injection test code so you can cause
a device to become unresponsive and trigger the timeout handling.

This latest is otherwise stable on my dev machine.
--8323328-238916323-1402934225=:4699--
