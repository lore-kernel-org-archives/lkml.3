Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaFPQtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:49:49 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:44067 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaFPQtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:49:47 -0400
Message-ID: <539F2027.1060805@bjorling.me>
Date: Mon, 16 Jun 2014 18:49:43 +0200
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: willy@linux.intel.com, sbradshaw@micron.com, axboe@fb.com,
        tom.leiming@gmail.com, hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v8] NVMe: convert to blk-mq
References: <1402661396-19207-1-git-send-email-m@bjorling.me> <1402661396-19207-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406160931400.4699@AMR>
In-Reply-To: <alpine.LRH.2.03.1406160931400.4699@AMR>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Den 16-06-2014 17:57, Keith Busch skrev:
> On Fri, 13 Jun 2014, Matias Bjørling wrote:
>> This converts the current NVMe driver to utilize the blk-mq layer.
>
>> static void nvme_reset_notify(struct pci_dev *pdev, bool prepare)
>> {
>> -       struct nvme_dev *dev = pci_get_drvdata(pdev);
>> +    struct nvme_dev *dev = pci_get_drvdata(pdev);
>>
>> -       if (prepare)
>> -               nvme_dev_shutdown(dev);
>> -       else
>> -               nvme_dev_resume(dev);
>> +    spin_lock(&dev_list_lock);
>> +    if (prepare)
>> +        list_del_init(&dev->node);
>> +    else
>> +        list_add(&dev->node, &dev_list);
>> +    spin_unlock(&dev_list_lock);
>> }
>> +        if (nvme_create_queue(dev->queues[i], i))
>>             break;
>> }
>
> The above change was just error injection test code so you can cause
> a device to become unresponsive and trigger the timeout handling.

Thanks, I'll take it off

>
> This latest is otherwise stable on my dev machine.

I'm very happy to hear!

