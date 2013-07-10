Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3GJCNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 22:13:45 -0400
Received: from ozlabs.org ([203.10.76.45]:39743 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab3GJCNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 22:13:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        qemu-devel@nongnu.org
Subject: Re: virtio indirect with lots of descriptors
In-Reply-To: <CAPM=9tzTUuOjmicjKs+OWirLz6+oHKJgnHjKHAd7WLv8JGmKCA@mail.gmail.com>
References: <CAPM=9tzTUuOjmicjKs+OWirLz6+oHKJgnHjKHAd7WLv8JGmKCA@mail.gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 10 Jul 2013 11:42:30 +0930
Message-ID: <87sizncgdt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie <airlied@gmail.com> writes:
> Hi Rusty,
>
> playing with my virtio gpu, I started hitting the qemu
> error_report("Too many read descriptors in indirect table");
>
> Now I'm not sure but this doesn't seem to be a virtio limit that the
> guest catches from what I can see, since my host dies quite quickly,
> when I'm doing transfers in/out of a 5MB object with an sg entry per
> page.
>
> Just wondering if you can confirm if this is only a qemu limitation or
> if I should just work around it at a bit of a higher level in my
> driver/device?

You're not allowed to place more descriptors in a single request than
there are elements in the ring *even* if you use indirects, which are
seen as an optimization (thus you can always fall back to direct
descriptors if OOM).

We could change this rule in the 1.0 spec if required, or even make a
special rule for your device, but for the moment that's how it is.

Hope that helps,
Rusty.
