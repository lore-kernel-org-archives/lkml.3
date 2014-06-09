Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501AbaFIPfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:35:04 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:45154 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFIPfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:35:01 -0400
MIME-Version: 1.0
In-Reply-To: <5395D24D.9000306@fb.com>
References: <1402057225-7312-1-git-send-email-m@bjorling.me>
	<1402057225-7312-2-git-send-email-m@bjorling.me>
	<CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>
	<5395BFF2.2080402@fb.com>
	<20140609145944.GA30626@infradead.org>
	<5395D24D.9000306@fb.com>
Date: Mon, 9 Jun 2014 23:35:00 +0800
Message-ID: <CACVXFVNNm5PJ8g=QD5zm49kaqW_oKCM+utMz+qSd=3WfsE4U2g@mail.gmail.com>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Matias Bj??rling" <m@bjorling.me>,
        Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 11:27 PM, Jens Axboe <axboe@fb.com> wrote:
> On 2014-06-09 08:59, Christoph Hellwig wrote:
>>
>> On Mon, Jun 09, 2014 at 08:08:50AM -0600, Jens Axboe wrote:
>>>>
>>>> [  487.704074] nvme 0000:00:07.0: Cancelling I/O 202 QID 1
>>>> [  487.717881] nvme 0000:00:07.0: Aborting I/O 202 QID 1
>>>> [  487.736093] end_request: I/O error, dev nvme0n1, sector 91532352
>>>> [  487.747378] nvme 0000:00:07.0: completed id 0 twice on queue 0
>>>>
>>>>
>>>> when running fio randread(libaio, iodepth:64) with more than 3 jobs.
>>>>
>>>> And looks no such failure when jobs is 1 or 2.
>>>
>>>
>>> It's a known issue, make sure you have this patch:
>>>
>>>
>>> https://urldefense.proofpoint.com/v1/url?u=http://git.kernel.dk/?p%3Dlinux-block.git%3Ba%3Dcommit%3Bh%3Df6be4fb4bcb396fc3b1c134b7863351972de081f&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=3JMVyziIyZtZ5cv9eWNLwQ%3D%3D%0A&m=MKK7A%2B9AnXXwtMV9YPSFEprXId0z0WLtd2JQPxnaNVc%3D%0A&s=45425e5d17390ae912457035ff081b95a7084725706ffe91166a1bdb25d8bf3d
>>
>>
>> So without this patch we can get duplicate completions?  That could
>> explain the issues that Robert sees with scsi-mq and hpsa..

Use-after-free may cause duplicate completions.

BTW, is the scsi-mq patchset public now?

Thanks,
-- 
Ming Lei
