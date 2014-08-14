Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaHNPj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:39:57 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:33383 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbaHNPj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:39:56 -0400
Message-ID: <53ECD842.40302@bjorling.me>
Date: Thu, 14 Aug 2014 17:39:46 +0200
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Keith Busch <keith.busch@intel.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Rob Nelson <rlnelson@google.com>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v11] NVMe: Convert to blk-mq
References: <1406365643-27020-1-git-send-email-m@bjorling.me> <1406365643-27020-2-git-send-email-m@bjorling.me> <CAOu_J6mW-2e2Jgm+khodLPah_-RZrD599SmSH+Mszd0AjterrQ@mail.gmail.com> <alpine.LRH.2.03.1408131519590.14603@AMR> <53EC7273.5060303@bjorling.me> <53ECD125.3080701@fb.com>
In-Reply-To: <53ECD125.3080701@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>>> I haven't event tried debugging this next one: doing an insmod+rmmod
>>> caused this warning followed by a panic:
>>>
>>
>> I'll look into it. Thanks
>
> nr_tags must be uninitialized or screwed up somehow, otherwise I don't
> see how that kmalloc() could warn on being too large. Keith, are you
> running with slab debugging? Matias, might be worth trying.

Thanks for the hint.

Keith, I'll first have a chance to fix it tomorrow. Let me know if you 
find it in the mean time.

I've put up a nvmemq_v12 on the github repository with the q_suspended 
removed.
