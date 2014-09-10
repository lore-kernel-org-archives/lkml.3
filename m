Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaIJPVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:21:23 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:34699 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaIJPVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:21:21 -0400
MIME-Version: 1.0
In-Reply-To: <54106BBF.7010907@redhat.com>
References: <1410044994-14943-1-git-send-email-hch@lst.de>
	<CACVXFVMRqgEh7EFQ0cDEatsqtxsgBrbSQNH9b6UZTsSD+=OWdA__14121.5735966854$1410309057$gmane$org@mail.gmail.com>
	<54106BBF.7010907@redhat.com>
Date: Wed, 10 Sep 2014 23:21:20 +0800
Message-ID: <CACVXFVNqFSFz7--VGi8j2aShT_QcVEqs0zxXkpgteqVMtqu18A@mail.gmail.com>
Subject: Re: [PATCH] virtio_blk: merge S/G list entries by default
From: Ming Lei <tom.leiming@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:18 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 07/09/2014 12:32, Ming Lei ha scritto:
>> It is a good idea to disable SG merge for vq incapable of indirect because
>> there are very limited direct descriptors.
>
> I think you mean _enabling_ SG merge if indirect descriptors are not there.

You are right, sorry for the typo.

>> For vq capable of indirect, it should be better to not do SG merge at default
>> because:
>>
>> - from hypervisor view, no matter how many segments one req has, all are
>> submitted to host kernel by one syscall, such as readv/io_submit
>>
>> - host kernel still need to do the same merge again
>
> Here we agree.
>
> Paolo
>
>> From my test(virtio-blk over null_blk), looks enabling SG merge may cause
>> throughput a little drop(~3%).
>


Thanks,
-- 
Ming Lei
