Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaJ0Xcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:32:48 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:36291 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaJ0Xcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:32:47 -0400
MIME-Version: 1.0
In-Reply-To: <20141027140826.GJ4436@htj.dyndns.org>
References: <1414249558-6677-1-git-send-email-zzhsuny@gmail.com>
	<20141027140826.GJ4436@htj.dyndns.org>
Date: Mon, 27 Oct 2014 19:32:47 -0400
Message-ID: <CADFvMYKRcqcZSbMz8sHGGknUC7p7i3MvGO5vKabrrzeWj+qUTw@mail.gmail.com>
Subject: Re: [PATCH] [percpu] Make the unit size of the first chunk the same
 as other chunks
From: Zhihui Zhang <zzhsuny@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pcpu_embed_first_chunk(), we allocate full unit size for each CPU
in the first chunk:

1981                 /* allocate space for the whole group */
1982                 ptr = alloc_fn(cpu, gi->nr_units * ai->unit_size,
atom_size);
1983                 if (!ptr) {
1984                         rc = -ENOMEM;
1985                         goto out_free_areas;
1986                 }


Later we freed unused part:


2009                         /* copy and return the unused part */
2010                         memcpy(ptr, __per_cpu_load, ai->static_size);
2011                         free_fn(ptr + size_sum, ai->unit_size - size_sum);

I am trying to make each CPU to have a full unit size in the first
chunk, same as in all other chunks. Does this make sense?

-Zhihui

On Mon, Oct 27, 2014 at 10:08 AM, Tejun Heo <tj@kernel.org> wrote:
> On Sat, Oct 25, 2014 at 11:05:58AM -0400, Zhihui Zhang wrote:
>> Since we have already allocated the full unit size for the first chunk, we might as well use
>> it so that the unit size are the same for all chunks. The page first chunk allocator already
>> has this effect because it allocates one page at a time.
>
> I'm not following.  Where do we allocate the full unit size for the
> first chunk?
>
> Thanks.
>
> --
> tejun
