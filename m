Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbaE3QHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:07:19 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:51297 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaE3QHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:07:16 -0400
Date: Fri, 30 May 2014 12:07:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140530160712.GG24871@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paolo.

On Thu, May 29, 2014 at 11:05:31AM +0200, Paolo Valente wrote:
> this patchset introduces the last version of BFQ, a proportional-share
> storage-I/O scheduler. BFQ also supports hierarchical scheduling with
> a cgroups interface. The first version of BFQ was submitted a few
> years ago [1]. It is denoted as v0 in the patches, to distinguish it
> from the version I am submitting now, v7r4. In particular, the first
> two patches introduce BFQ-v0, whereas the remaining patches turn it
> progressively into BFQ-v7r4. Here are some nice features of this last
> version.

So, excellent work.  I haven't acteually followed the implementation
of the scheduling logic itself but read all the papers and it seems
great to me; however, the biggest problem that I have is that while
being proposed as a separate iosched, this basically is an improvement
of cfq.  It shares most of the infrastructure code, aims the same set
of devices and usages scenarios and while a lot more clearly
characterized and in general better performing even the scheduling
behavior isn't that different from cfq.

We do have multiple ioscheds but sans for anticipatory which pretty
much has been superceded by cfq, they serve different purposes and I'd
really hate the idea of carrying two mostly similar ioscheds in tree.

For some reason, blkcg implementation seems completely different but
outside of that, bfq doesn't really seem to have diverged a lot from
cfq and the most likely and probably only way for it to be merged
would be if you just mutate cfq into bfq.  The whole effort is mostly
about characterizing and refining the scheduling algorithm anyway,
right?  I'd really love to see that happening.

Thanks.

-- 
tejun
