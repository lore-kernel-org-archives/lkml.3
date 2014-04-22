Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbaDVOTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:19:39 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37302 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbaDVOTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <535679A4.4050507@kernel.dk>
References: <1398144370-9236-1-git-send-email-nasa4836@gmail.com> <535679A4.4050507@kernel.dk>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 22:18:55 +0800
Message-ID: <CAHz2CGXcTZZHYK1WbOcF3S-O74dxE+yN9z527KhgOOEcfD_-DQ@mail.gmail.com>
Subject: Re: [PATCH] blk-cgroup: explicitly init the early_init field
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:16 PM, Jens Axboe <axboe@kernel.dk> wrote:
> The rest of the members will be zero-filled by default, so your patch should
> not change anything.

Hi, Jens

I'm sorry I should have made this more clear.

Sure, for this global variable struct, if not initailized, its all
fields will be initialized
to 0 or null(depending on its type).  The point here is no to deprive
the rights of compiler/linker of doing this initialization, it is mainly for
documentation reason. Actually this field's value would affect how ->css_alloc
should implemented.

Concretely, if early_init is nonzero, then ->css_alloc *must not* call kzalloc,
because in cgroup implementation, ->css_alloc will be called earlier before
mm_init().

I don't think that the value of one field(early_init) has a so subtle
restrition on the another field(css_alloc) is a good thing, but since
it is there, docment it should be needed.

Thanks,
Jianyu Zhan
