Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbaDWUBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:01:30 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:64497 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442AbaDWUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:01:28 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXE_T-3eKmVKZNkAfoyvC0CcUATDK7fGPvQrR9H=RHQag@mail.gmail.com>
References: <CALCETrXE_T-3eKmVKZNkAfoyvC0CcUATDK7fGPvQrR9H=RHQag@mail.gmail.com>
Date: Wed, 23 Apr 2014 22:01:27 +0200
Message-ID: <CAFLxGvyn4q3VfRrAcjO6meZ1UJwRZ5-yeaMExGX5ogtnuAkPBQ@mail.gmail.com>
Subject: Re: How do I make a clean mount namespace?
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 12:12 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> I want to set up a little container.  So I unshare the mount namespace
> and mount something somewhere (say /mnt) that I want to be my new
> root.  Now what?
>
> pivot_root("/mnt", "/mnt/garbage") seems to frequently return -EBUSY.
>
> mounting /mnt onto / using MS_MOVE seems to succeed, but / still
> points at the old root.
>
> Am I missing a clean way to do this?  I want a way to say "make this
> mountpoint be the root of the whole mount namespace and lazy-unmount
> everything outside it".  If there is no straightforward way to do
> that, can we add one?

I fear you have to read /proc/mounts and umount() everything in the
correct order.
If you find a better way, please tell. :-)

-- 
Thanks,
//richard
