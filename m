Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaFJOrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:47:17 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58672 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaFJOrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140610124508.GA5671@lst.de>
References: <1402375925-21720-1-git-send-email-tom.leiming@gmail.com>
	<20140610112827.GA359@lst.de>
	<CACVXFVNxSh7ryy2vfnoNYpvmnjU0+TcipgdZxJ3tDbu-RBY=zA@mail.gmail.com>
	<20140610124508.GA5671@lst.de>
Date: Tue, 10 Jun 2014 22:47:13 +0800
Message-ID: <CACVXFVO3XPd99ARZ+55ttas9ZKNNcUYkC0ckaaENvBGMrQnyUQ@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: kick requeue list in blk_mq_requeue_request()
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 8:45 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Tue, Jun 10, 2014 at 07:45:47PM +0800, Ming Lei wrote:
>> OK, but the API name is a bit confusing, and that is easy to cause
>> misuse, like in nvme.
>>
>> Also requeue one request in completion handler may be a
>> common case, so maybe it is better to let blk_mq_requeue_request()
>> handle both adding to request list and kicking off, and introduce
>> blk_mq_prep_requeue_req()(or better name) to batch operations.
>
> For now please just add some documentation.  I'm happy to revisit
> these once we have a few user in tree, but for now I'd like to keep
> blk-mq a little more stable to not impact the merges of the major
> users.

There are two users: one is nvme, another is scsi-mq, and both
don't need batch operations now.


Thanks,
-- 
Ming Lei
