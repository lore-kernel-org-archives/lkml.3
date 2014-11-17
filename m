Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaKQKcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:32:10 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49605 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaKQKcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:32:08 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20141114095511.789a76ac@gmail.com>
References: <20141107170242.GA333@tucsk>
	<20141108192723.444cecd2@gmail.com>
	<20141110090954.GB333@tucsk>
	<20141114095511.789a76ac@gmail.com>
Date: Mon, 17 Nov 2014 11:32:07 +0100
Message-ID: <CAJfpegvYBMbhbmpA2kB01qQ3u5ict7rgWib4tx=941yyzqJBMQ@mail.gmail.com>
Subject: Re: [RFC PATCH] overlayfs: support more than one read-only layer
From: Miklos Szeredi <miklos@szeredi.hu>
To: Jordi Pujol Palomer <jordipujolp@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "A. Wan" <jm@mokwan.com>,
        Patrick Frisch <patrick@mekufemo6lbi9soa.myfritz.net>,
        Aaron Campbell <aaron@arbor.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 9:55 AM, Jordi Pujol Palomer
<jordipujolp@gmail.com> wrote:
> EL Mon, 10 Nov 2014 10:09:54 +0100
> Miklos Szeredi <miklos@szeredi.hu> escrigué:
>
>> Maybe it wasn't clear, but the number of lower layers isn't limited by
>> FILESYSTEM_MAX_STACK_DEPTH,
> sorry, you have been clear, it's me that have not explained the purpose
> of that patch. This idea is also valid for the main overlayfs
> development.
> Consider that we have an encrypted partition and a live OS that
> uses overlayfs and works over it, when the OS is started already
> reaches the maximum stacking depth (2). Also, hardcoding parameters
> into the code may be annoying because a change implies creating and
> mantaining patches, otherwise when the parameter is configurable we can
> change it in a config value.

Before allowing a change to FILESYSTEM_MAX_STACK_DEPTH we'd need to
analyze the kernel stack usage of anything taking part in the
filesystem stack.  Not something that can be expected of users before
they set a kernel config variable.

'Course we can change overlayfs and/or ecryptfs to use a new context
for operations done on underlying layers.  Not sure how much work that
would be...

> Also, I include a patch to explain better my first statement,
> would say lowerdirs has extended the functionality of lowerdir,
> therefore we can discard the lowerdir case that only works with one
> lower layer and rename lowerdirs to lowerdir. It's more simple and all
> the functionality is preserved.

Yeah.  But we also need some escaping in 'lowerdir=' argument to allow
filenames with comma and colon.  Current patch doesn't yet have that,
but will work on it.

Thanks,
Miklos
