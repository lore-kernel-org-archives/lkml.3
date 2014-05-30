Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109AbaE3TdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:33:19 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:60891 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbaE3TdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:33:18 -0400
Message-ID: <5388DCF9.9000204@bjorling.me>
Date: Fri, 30 May 2014 21:33:13 +0200
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: willy@linux.intel.com, sbradshaw@micron.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4] NVMe: basic conversion to blk-mq
References: <1401400285-25003-1-git-send-email-m@bjorling.me> <1401400285-25003-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1405301027350.11244@AMR>
In-Reply-To: <alpine.LRH.2.03.1405301027350.11244@AMR>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 06:48 PM, Keith Busch wrote:
> On Thu, 29 May 2014, Matias Bjørling wrote:
>> This converts the current NVMe driver to utilize the blk-mq layer.
> 
> I'm pretty darn sure this new nvme_remove can cause a process
> with an open reference to use queues after they're freed in the
> nvme_submit_sync_command path, maybe even the admin tags too.
> 

You're right. I'll put a fix in v5.

>> @@ -2802,7 +2574,7 @@ static void nvme_remove(struct pci_dev *pdev)
>>     nvme_dev_remove(dev);
>>     nvme_dev_shutdown(dev);
>>     nvme_free_queues(dev, 0);
>> -    rcu_barrier();
>> +    nvme_free_admin_tags(dev);
>>     nvme_release_instance(dev);
>>     nvme_release_prp_pools(dev);
>>     kref_put(&dev->kref, nvme_free_dev);

