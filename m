Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaGTRjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 13:39:53 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35040 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaGTRjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 13:39:52 -0400
MIME-Version: 1.0
In-Reply-To: <84D489B9-FC60-40F1-A03F-996256F790A9@holtmann.org>
References: <84D489B9-FC60-40F1-A03F-996256F790A9@holtmann.org>
Date: Sun, 20 Jul 2014 10:39:51 -0700
X-Google-Sender-Auth: zZcjmH4lq-LekLvq3LiMbVfYtI8
Message-ID: <CAGXu5jJbrEryxx7e48Mc0Pi18vEBfHWN-pOxrvDnC24Lr21ghQ@mail.gmail.com>
Subject: Re: Commit d9e7972619334656 breaks KVM's virtio-rng-pci
From: Kees Cook <keescook@chromium.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 9:18 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hello,
>
> the commit d9e7972619334656 ends up being responsible that using "-device virtio-rng-pci" in KVM no longer works.
>
>         From: Kees Cook <keescook@chromium.org>
>         Date: Mon, 3 Mar 2014 15:51:48 -0800
>         Subject: [PATCH] hwrng: add randomness to system from rng sources
>
>         When bringing a new RNG source online, it seems like it would make sense
>         to use some of its bytes to make the system entropy pool more random,
>         as done with all sorts of other devices that contain per-device or
>         per-boot differences.
>
> When providing "-device virtio-rng-pci" to a kernel with the above commit, the kernel never finishes booting. It just stops. My guess it is waiting for some magic entropy to appear.
>
> Maybe this is something that should be fixed in virtio-rng driver instead of reverting this patch, but I leave this to the experts in this area.

Yup, this has already been handled. See various threads around:
https://lkml.org/lkml/2014/7/5/14

-Kees

-- 
Kees Cook
Chrome OS Security
