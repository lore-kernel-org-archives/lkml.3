Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3C0QyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:54:12 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:64888 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3C0QyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:54:10 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx=BPQ2empEahqCs2hQ=sRaw3OjJotrS6OMT3e6tUVMLQ@mail.gmail.com>
References: <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
 <20130310221047.GA21522@ZenIV.linux.org.uk> <20130311003530.GE21522@ZenIV.linux.org.uk>
 <CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
 <20130311180543.GF21522@ZenIV.linux.org.uk> <20130312130614.GA32237@ZenIV.linux.org.uk>
 <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
 <20130312194353.GI21522@ZenIV.linux.org.uk> <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
 <20130327135127.GB1738@redhat.com> <20130327152030.GY21522@ZenIV.linux.org.uk>
 <CA+55aFx=BPQ2empEahqCs2hQ=sRaw3OjJotrS6OMT3e6tUVMLQ@mail.gmail.com>
From: Raymond Jennings <shentino@gmail.com>
Date: Wed, 27 Mar 2013 09:53:29 -0700
Message-ID: <CAGDaZ_o41yX8i1+dGHzpTB4uDuKRtx-7jQNk_vhi_6E9cc47OQ@mail.gmail.com>
Subject: Re: Yet another pipe related oops.
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 9:33 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 27, 2013 at 8:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> Actually, that's my fault - check lost in patch reordering.  My apologies ;-/
>> Eventually, we want that in fs/splice.c side of things (no point repeating it
>> for every buffer, after all), but for now this is the obvious minimal fix.
>
> Applied.
>
> Do we actually have files with NULL f_ops pointers? Should we? What
> could we possibly do with a file descriptor that doesn't have any
> fops?

For the sake of the curious including myself:

How would such a NULL f_ops file get created in the first place?

> Also, perhaps we should do something more akin to what we do for
> dentry functions where we validate them on registration, and we could
> fix up or validate read/write pointers, with semantics something like
>
>     if (!fop->write)
>         fop->write = fop->aio_write ? do_sync_write : EINVAL_write;
>     if (!fop->read)
>         fop->read = fop->aio_read ? do_sync_read : EINVAL_read;
>
> kind of things?
>
> Not a big deal, perhaps.
>
>               Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
