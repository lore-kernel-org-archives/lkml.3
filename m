Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaDNIkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:40:17 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:50733 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaDNIkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:40:14 -0400
MIME-Version: 1.0
In-Reply-To: <CADDKRnCakz_HE2P+vZat2QVEbpebv4zr2gN3+RbkQvw1rA_Bpg@mail.gmail.com>
References: <CADDKRnCakz_HE2P+vZat2QVEbpebv4zr2gN3+RbkQvw1rA_Bpg@mail.gmail.com>
Date: Mon, 14 Apr 2014 10:40:14 +0200
Message-ID: <CADDKRnC6e33bEunvkS42UCX_rAJpbQah4x7YCB=7fwr6EBd1NA@mail.gmail.com>
Subject: Re: [ 3.14.0-12041-g75ff24f ] regression: drm warning
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-09 12:08 GMT+02:00 Jörg Otte <jrg.otte@gmail.com>:
> Kernel 3.14.0-12041-g75ff24f from 9.4.2014 introduces the following
> on the console (driver is i915):
>
> [drm:ivb_err_int_handler] *ERROR* Pipe B FIFO underrun
> [drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun
> [drm:cpt_serr_int_handler] *ERROR* PCH transcoder B FIFO underrun
>
> In syslog I find:
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 1 at
> /data/kernel/linux/drivers/gpu/drm/drm_mm.c:211 0xffffffffb22a70fa()
> no hole found for node 0x0 + 0x300000
> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-12041-g75ff24f #45
> Hardware name: FUJITSU LIFEBOOK AH532/FJNBB1C, BIOS Version 1.09 05/22/2012
>  0000000000000000 ffffffffb2967138 ffffffffb262ae5d ffff8802160d5a58
>  ffffffffb20391ad ffff880214994000 0000000000300000 0000000000000000
>  ffff880214952800 0000000000000000 ffffffffb2039255 ffffffffb2967190
> Call Trace:
>  [<ffffffffb262ae5d>] ? 0xffffffffb262ae5d
>  [<ffffffffb20391ad>] ? 0xffffffffb20391ad
>  [<ffffffffb2039255>] ? 0xffffffffb2039255
>  [<ffffffffb22a70fa>] ? 0xffffffffb22a70fa
>  [<ffffffffb22d4b11>] ? 0xffffffffb22d4b11
>  [<ffffffffb2300f92>] ? 0xffffffffb2300f92
>  [<ffffffffb232af7b>] ? 0xffffffffb232af7b
>  [<ffffffffb232f675>] ? 0xffffffffb232f675
>  [<ffffffffb21fa38c>] ? 0xffffffffb21fa38c
>  [<ffffffffb232ec04>] ? 0xffffffffb232ec04
>  [<ffffffffb2622997>] ? 0xffffffffb2622997
>  [<ffffffffb232ee62>] ? 0xffffffffb232ee62
>  [<ffffffffb22a6a5b>] ? 0xffffffffb22a6a5b
>  [<ffffffffb22a3994>] ? 0xffffffffb22a3994
>  [<ffffffffb22a5a38>] ? 0xffffffffb22a5a38
>  [<ffffffffb221a019>] ? 0xffffffffb221a019
>  [<ffffffffb23327b8>] ? 0xffffffffb23327b8
>  [<ffffffffb2332a03>] ? 0xffffffffb2332a03
>  [<ffffffffb2332970>] ? 0xffffffffb2332970
>  [<ffffffffb2330c45>] ? 0xffffffffb2330c45
>  [<ffffffffb2331534>] ? 0xffffffffb2331534
>  [<ffffffffb2332fce>] ? 0xffffffffb2332fce
>  [<ffffffffb2aa2cc5>] ? 0xffffffffb2aa2cc5
>  [<ffffffffb2a7fe45>] ? 0xffffffffb2a7fe45
>  [<ffffffffb2052100>] ? 0xffffffffb2052100
>  [<ffffffffb2a7ffe2>] ? 0xffffffffb2a7ffe2
>  [<ffffffffb2a7f79e>] ? 0xffffffffb2a7f79e
>  [<ffffffffb2624d20>] ? 0xffffffffb2624d20
>  [<ffffffffb2624d29>] ? 0xffffffffb2624d29
>  [<ffffffffb263223c>] ? 0xffffffffb263223c
>  [<ffffffffb2624d20>] ? 0xffffffffb2624d20
> ---[ end trace 0d3f14b61bc31dab ]---
>
> This does not happen in 3.14.0-11030-ga7963eb from 8.4.2014 and never
> before.
>
> Suppose merge
> 12024   e9f37d3 Merge branch 'drm-next' of
> git://people.freedesktop.org/~airlied/linux
> produces this problem.
>

cc to more people..

Jörg
