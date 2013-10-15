Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab3JOSOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:14:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35292 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3JOSOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:14:06 -0400
Date: Tue, 15 Oct 2013 12:14:03 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: blk_mq_update_queue_map makes an (invalid?) assumption about cpu
 ordering
Message-ID: <20131015181403.GY541@kernel.dk>
References: <x49fvs2pgjx.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49fvs2pgjx.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15 2013, Jeff Moyer wrote:
> Hi, Jens,
> 
> blk_mq_update_queue_map does this:
> 
>         for_each_possible_cpu(i) {
>                 if (!cpu_online(i)) {
>                         map[i] = 0;
>                         continue;
>                 }
> 
> ...
>                 first_sibling = get_first_sibling(i);
>                 if (first_sibling == i) {
>                         map[i] = cpu_to_queue_index(nr_uniq_cpus, nr_queues,
>                                                         queue);
>                         queue++;
>                 } else
>                         map[i] = map[first_sibling];
> 
> This assumes that the first_sibling is listed before any other siblings,
> which I don't believe is true.  I don't think you get any guaranteed
> ordering in that cpu_possible_mask.
> 
> ... or did I miss something?

That's correct, it's assuming the first sibling is the lowest numbered
one. Are there cases where that would not be correct? I was sort of
assuming that was what "first" meant here.

-- 
Jens Axboe

