Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaHXRSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:18:13 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:54292 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaHXRSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+ydwtq7-O4+5jtu_zZEFGM7Nbq7pGqGG=UgZBnDzg58QsgMoA@mail.gmail.com>
References: <CA+ydwtoGKP622R5XSSSvibd_5PtsQxtsijrdD23c-7waQvjC=g@mail.gmail.com>
	<CANq1E4TZPZQSP2wWLG2LJmf1YXyRnv0rtMyKGkjsfSV50RDSnA@mail.gmail.com>
	<CA+ydwtq7-O4+5jtu_zZEFGM7Nbq7pGqGG=UgZBnDzg58QsgMoA@mail.gmail.com>
Date: Sun, 24 Aug 2014 19:18:11 +0200
Message-ID: <CANq1E4S97B_RA+WQbsHe8JQsVnqTS3g6=uR3EQFN9n9bptFV2w@mail.gmail.com>
Subject: Re: drm_mode_create_dumb_ioctl: divide error
From: David Herrmann <dh.herrmann@gmail.com>
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        trinity@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Aug 24, 2014 at 7:12 PM, Tommi Rantala <tt.rantala@gmail.com> wrote:
> (gdb) info locals
> cpp = 0
> stride = 0
> size = <optimized out>
>
> (gdb) print /x *(struct drm_mode_create_dumb *)data
> $13 = {
>   height = 0xffffffff,
>   width = 0xffffffff,
>   bpp = 0xffffffff,
>   flags = 0xffffffff,
>   handle = 0xffffffff,
>   pitch = 0xffffffff,
>   size = 0xffffffffffffffff
> }

Thanks a lot for digging into this. Looks like DIV_ROUND_UP() can
overflow... *check*
Yes, it's defined as:
        #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))

Kinda unexpected that a function called "DIV" can overflow, but makes
sense here. Obvious fix is to test "cpp" for zero. I will send it to
dri-devel.

Thanks!
David
