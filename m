Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab3DAWxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:53:30 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:34331 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379Ab3DAWx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:53:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMFOmWuo5W53G1-eAONgMqPRrt7HUorVk-HfpBzuddOJD=fjQ@mail.gmail.com>
References: <1364817485-19676-1-git-send-email-anatol.pomozov@gmail.com>
	<CA+55aFzqYkX27E8R7Bu8pvn3xO+hKrgMEC7ec5gDz4kr1JbVtQ@mail.gmail.com>
	<CAOMFOmWuo5W53G1-eAONgMqPRrt7HUorVk-HfpBzuddOJD=fjQ@mail.gmail.com>
Date: Mon, 1 Apr 2013 15:53:25 -0700
X-Google-Sender-Auth: r4e06bmkF9NX0AWBw6swSEdz7K8
Message-ID: <CA+55aFx1UsimN8AKvNP=UzM_4E2h48XuDxhBwk3MYQ7NC2Zazg@mail.gmail.com>
Subject: Re: [PATCH] loop: prevent bdev freeing while device in use
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anatol Pomozov <anatol.pomozov@gmail.com>, stable <stable@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Salman Qazi <sqazi@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Guo Chao <yan@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 10:00 AM, Anatol Pomozov
<anatol.pomozov@gmail.com> wrote:
> Hi
>
> On Mon, Apr 1, 2013 at 8:16 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Mon, Apr 1, 2013 at 4:58 AM, Anatol Pomozov <anatol.pomozov@gmail.com> wrote:
>>>
>>> To prevent use-after-free we need to hold device inode in loop_set_fd()
>>> and put it later in loop_clr_fd().
>>
>> Is there something that guarantees that there's only one loop_set_fd()
>> and one paired loop_clr_fd()?
>
> Yes there is such guarantee.
>
> Every time we call loop_set_fd() we check that loop_device->lo_state
> is Lo_unbound and set it to Lo_bound  If somebody will try to set_fd
> again it will get EBUSY. And if we try to loop_clr_fd() on unbound
> loop device we'll get ENXIO.
>
> loop_set_fd/loop_clr_fd (and any other loop ioctl) is called under
> loop_device->lo_ctl_mutex.

Ok, good enough for me, I applied it, and it's commit
c1681bf8a7b1b98edee8b862a42c19c4e53205fd in my tree.

I assume it should go to stable too, because none of this is new, is
it? Did you check how far back this applies? I assume this goes back
pretty much forever, no?

               Linus
