Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaLOKDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:03:16 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:57792 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaLOKDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:03:13 -0500
MIME-Version: 1.0
In-Reply-To: <1418575877-21488-1-git-send-email-mst@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
Date: Mon, 15 Dec 2014 18:03:10 +0800
Message-ID: <CAFiDJ5_fGWx2E1jvU+k0Tv_esRpWmC-p+kq7Y_VOr5bx2ZUFzg@mail.gmail.com>
Subject: Re: [PATCH 00/18] uaccess: fix sparse warning on get_user for bitwise types
From: "LF.Tan" <lftan.linux@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 12:51 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> At the moment, if p and x are both tagged as bitwise types,
> get_user(x, p) produces a sparse warning on many architectures.
> This is because *p on these architectures is loaded into long
> (typically using asm), then cast back to typeof(*p).
>
> When typeof(*p) is a bitwise type (which is uncommon), such a cast needs
> __force, otherwise sparse produces a warning.
>
> Some architectures already have the __force tag, add it
> where it's missing.
>
> Specificlly, vhost wants to read bitwise types from userspace using get_user.
> At the moment this triggers sparse errors, since the value is passed through an
> integer.
>
> For now, I worked around this by converting vhost code to access_ok +
> __get_user, but that's not robust, I'd like to switch to get_user for 3.19.
>
> I tested this on x86 only so far. Since it's just adding __force, should be
> trivially safe everywhere?
>
> Please review, and consider for 3.19.
>
> Who can merge this? Arnd?
Hi Michael

FYI, there is new arch (arch/nios2) in 3.19. Is your patchset include
the fix for it?
Thanks.

Regards
Ley Foon
