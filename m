Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaE1C00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 22:26:26 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:46439 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaE1C0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 22:26:25 -0400
Message-ID: <5385494E.1070803@kernel.dk>
Date: Tue, 27 May 2014 20:26:22 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
 flush worker
References: <20140520152303.GA20352@lst.de>	<CACVXFVNP--zj_-UtygxfXk7GvSXwKm2KMKFs=h9KsrL=ZzbWVQ@mail.gmail.com>	<20140521053634.GA4764@lst.de>	<CACVXFVO5znzYtPKMTPwx_2MU97xFZY+wHwm+R33T043SW4JHHw@mail.gmail.com>	<20140527181305.GA7975@lst.de>	<5384DB97.70606@kernel.dk>	<20140527185301.GA8466@lst.de>	<5384DF5E.3020304@kernel.dk>	<20140527191510.GA9274@lst.de>	<5384E4D4.6040101@kernel.dk>	<20140527192130.GA9850@lst.de>	<5384E8FA.8080201@kernel.dk> <CACVXFVM6YYW8N0wpKGchAVpLk72qJiqHwiUg4S4Yv+M+o-B=9g@mail.gmail.com>
In-Reply-To: <CACVXFVM6YYW8N0wpKGchAVpLk72qJiqHwiUg4S4Yv+M+o-B=9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-27 19:34, Ming Lei wrote:
> On Wed, May 28, 2014 at 3:35 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 05/27/2014 01:21 PM, Christoph Hellwig wrote:
>>> On Tue, May 27, 2014 at 01:17:40PM -0600, Jens Axboe wrote:
>>>> But I think you sent the old one again, not the new variant :-)
>>>
>>> Oh well, next try:
>>
>> This looks good to me. Was trying to think of ways to reduce that to one
>> list iteration, but I think it's cleaner to just retain the two separate
>> ones.
>>
>> Reusing REQ_SOFTBARRIER is fine as well, not used in blk-mq otherwise.
>>
>> Let me know when you have runtime verified it.
>
> Looks writing over ext4(especially sync writing) can survive
> with Christoph's patch now, thanks Christoph.
>
> Reported-and-tested-by: Ming Lei <tom.leiming@gmail.com>

Great! I'll queue it up here too, then.

-- 
Jens Axboe

