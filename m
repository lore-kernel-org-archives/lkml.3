Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaAAE5U (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 23:57:20 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:62767 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaAAE5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:57:19 -0500
MIME-Version: 1.0
In-Reply-To: <20131231163851.GJ21823@kernel.dk>
References: <1388064698-27344-1-git-send-email-tom.leiming@gmail.com>
	<1388064698-27344-2-git-send-email-tom.leiming@gmail.com>
	<20131231163851.GJ21823@kernel.dk>
Date: Wed, 1 Jan 2014 12:57:18 +0800
Message-ID: <CACVXFVO8XSZPLmkQ6JowEsJ41JcDsEdNCf5Qj5XpCL27NrOnPA@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] block: blk-mq: avoid initializing request during
 its completion
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Wed, Jan 1, 2014 at 12:38 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Thu, Dec 26 2013, Ming Lei wrote:
>> One problem is that request->start_time/start_time_ns could be
>> set as wrong.
>>
>> Also it is normal to intialize one data structure just after its
>> allocation.
>>
>> So move the initialization out of its completion path.
>
> It's done that way because of presumed cache hotness on completion,
> since we just touched a lot of the members. Lets just fix the start time
> issue by itself.

But some members of request are already touched in allocation
path(blk-mq core) too, and lots of members will be touched by
driver for starting the transfer.

Also I didn't observe obvious effect on L1 dcache load/store miss rate
after applying the patch when reading/writing on null_blk device.

Considered the theoretic advantage of reinitializing in free path, I
will just fix the start time issue by itself.

Thanks,
-- 
Ming Lei
