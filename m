Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaDVHNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:13:31 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36651 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaDVHNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:13:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140422060654.GB9133@gmail.com>
References: <1398144517-9496-1-git-send-email-nasa4836@gmail.com> <20140422060654.GB9133@gmail.com>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 15:12:45 +0800
Message-ID: <CAHz2CGW0D6GpbP7Tps2KoN8av_OUEzO9xGvpV_XwoHgFQ36sOw@mail.gmail.com>
Subject: Re: [PATCH] perf-event/cgroup: explicitly init the early_init field
To: Ingo Molnar <mingo@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 2:06 PM, Ingo Molnar <mingo@kernel.org> wrote:
> How can that field ever be nonzero?
>
> I.e. under what exact circumstances does this patch make sense?

Hi, Ingo,

More explanation.

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
it is there,
docment it should be needed.

I could resend the patch with  more comment.

Thanks,
Jianyu Zhan
