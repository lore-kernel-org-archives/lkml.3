Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3LZTv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:51:26 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43623 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab3LZTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:51:25 -0500
MIME-Version: 1.0
Date: Thu, 26 Dec 2013 11:51:22 -0800
Message-ID: <CAGXu5j+mBiXj2+iPKGU+Ffb3oXqL+cH8JULH_hoORJNiQgQQFQ@mail.gmail.com>
Subject: nouveau nvaa clock missing break?
From: Kees Cook <keescook@google.com>
To: Roy Spliet <rspliet@eclipso.eu>
Cc: Ben Skeggs <bskeggs@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just curious if this code is missing a "break" or not...

/drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c: 373 in nvaa_clock_prog()

        switch (priv->vsrc) {
        case nv_clk_src_cclk:
                mast |= 0x00400000;
        default:
                nv_wr32(clk, 0x4600, priv->vdiv);
        }

Coverity noticed it as CID 1135671. If it's intentional, it might be
nice to add a "fall through" comment there.

Coverity also complained about read_pll (CID 1135670) where post_div
could (unlikely) be 0 and used for a divide-by-zero.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
