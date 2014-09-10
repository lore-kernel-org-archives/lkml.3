Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaIJPS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:18:28 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63664 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaIJPS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:18:27 -0400
Message-ID: <54106BBF.7010907@redhat.com>
Date: Wed, 10 Sep 2014 17:18:23 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <axboe@kernel.dk>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio_blk: merge S/G list entries by default
References: <1410044994-14943-1-git-send-email-hch@lst.de> <CACVXFVMRqgEh7EFQ0cDEatsqtxsgBrbSQNH9b6UZTsSD+=OWdA__14121.5735966854$1410309057$gmane$org@mail.gmail.com>
In-Reply-To: <CACVXFVMRqgEh7EFQ0cDEatsqtxsgBrbSQNH9b6UZTsSD+=OWdA__14121.5735966854$1410309057$gmane$org@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2014 12:32, Ming Lei ha scritto:
> It is a good idea to disable SG merge for vq incapable of indirect because
> there are very limited direct descriptors.

I think you mean _enabling_ SG merge if indirect descriptors are not there.

> For vq capable of indirect, it should be better to not do SG merge at default
> because:
> 
> - from hypervisor view, no matter how many segments one req has, all are
> submitted to host kernel by one syscall, such as readv/io_submit
> 
> - host kernel still need to do the same merge again

Here we agree.

Paolo

> From my test(virtio-blk over null_blk), looks enabling SG merge may cause
> throughput a little drop(~3%).

