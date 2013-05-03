Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232Ab3ECU1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:27:08 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:33769 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763500Ab3ECU1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:27:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXV0wg3h4XU1JmpSOi01H8gaHkXKK=qYhnT5wpDd-mK-A@mail.gmail.com>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
	<CAMuHMdXV0wg3h4XU1JmpSOi01H8gaHkXKK=qYhnT5wpDd-mK-A@mail.gmail.com>
Date: Fri, 3 May 2013 22:27:03 +0200
X-Google-Sender-Auth: pJNieRJMNLIVccN1hjPZPwDKe5I
Message-ID: <CAMuHMdVQCcAzOUGNiwy1YPhbwCcF7mYeiv=cCuE9rs8HJuQ4-w@mail.gmail.com>
Subject: Re: [PATCH 00/28] Privatise procfs internals [RFC]
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 10:51 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Apr 16, 2013 at 8:25 PM, David Howells <dhowells@redhat.com> wrote:
>> Here is a series of patches to make the procfs internals private to the procfs
>> filesystem.  This is built on top of the patches to eliminate
>> create_proc_read_entry() after the kill-read_proc_t tag.
>>
>> These patches include fixes for the places that are attempting to abuse
>> proc_dir_entry->count and doing it incorrectly because PID namespaces now
>> exist.
>>
>> All accesses to the PDE struct have been replaced with out-of-line accessor
>> functions.  This is a bit less efficient than it used to be, but this could be
>> mitigated by using inode->i_private.
>>
>> The internal procfs structs have moved to fs/procfs/internal.h.  Some of the
>> remaining stuff in linux/proc_fs.h has been split out to linux/kcore.h and
>> linux/proc_ns.h as they's separate specialised intefaces.
>
> drivers/nubus/proc.c:156:7: error: dereferencing pointer to incomplete type
> drivers/nubus/proc.c:158:22: error: dereferencing pointer to incomplete type
> make[3]: *** [drivers/nubus/proc.o] Error 1
> make[2]: *** [drivers/nubus] Error 2

I've just sent out a patch to fix this.

> drivers/zorro/proc.c:142:7: error: dereferencing pointer to incomplete type
> make[3]: *** [drivers/zorro/proc.o] Error 1
> make[2]: *** [drivers/zorro] Error 2

This one is fixed in mainline.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
