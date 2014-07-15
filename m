Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaGQEze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 00:55:34 -0400
Received: from ozlabs.org ([103.22.144.67]:43370 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbaGQEza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 00:55:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Lucas Tanure <tanure@linux.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NoMoreModuleVmalloc - Try alloc_pages_exact before vmalloc, if fails do vmalloc
In-Reply-To: <CAJyon0sTcZNpWZaBmiUBv99T4=BRTfEV+sJukc4deGMN1ZPFyw@mail.gmail.com>
References: <20140713130407.GA27344@archDesk> <87lhrw4515.fsf@rustcorp.com.au> <CAJyon0sTcZNpWZaBmiUBv99T4=BRTfEV+sJukc4deGMN1ZPFyw@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 15 Jul 2014 21:04:17 +0930
Message-ID: <874myi5006.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas Tanure <tanure@linux.com> writes:
> Hi Russell,
>
> I found that project
> http://kernelnewbies.org/KernelProjects/NoMoreModuleVmalloc.
> So I thought that doing first a alloc_pages_exact would be the goal.
> The kernel/module.c doesn't need this task any more, or I just did in
> the wrong way ?

Hmm, that's hardly a newbie project!

arch/x86/kernel/module.c contains the module_alloc() code for x86.
You'd need to repalce that, and set module_free() too.

And it's not entirely clear that replacing it with kmalloc is actually
useful, since it will break CONFIG_DEBUG_SET_MODULE_RONX=y.

Cheers,
Rusty.
