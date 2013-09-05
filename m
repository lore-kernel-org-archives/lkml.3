Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab3IETCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:02:31 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:36190 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab3IETCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:02:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130905112441.0a8c81d2@samsung.com>
References: <20130905112441.0a8c81d2@samsung.com>
Date: Thu, 5 Sep 2013 12:02:29 -0700
X-Google-Sender-Auth: TNIMlrYDjPyUve8DRXT_wJKviWs
Message-ID: <CA+55aFybmupGxmnDfaYfKu2L1QyBW=EYG=jA3zBa=r1vfm+_EQ@mail.gmail.com>
Subject: Re: [GIT PULL for v3.12-rc1] media updates
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 7:24 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
>
> Also, a trivial conflict at s5p_mfc_dec.c and s5p_mfc_enc.c will happen as
> a macro name got renamed from IS_MFCV6 to IS_MFCV6_PLUS.

I did an "ugly merge" when fixing that conflict up, because the stupid
code at the conflict site did this:

                if (!IS_MFCV6_PLUS(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
                        mfc_err("Not supported format.\n");
                        return -EINVAL;
                }
                if (!IS_MFCV6_PLUS(dev)) {
                        if (fmt->fourcc == V4L2_PIX_FMT_VP8) {
                                mfc_err("Not supported format.\n");
                                return -EINVAL;
                        }
                }

and there was no way I was going to fix up the code and not remove the
idiotic duplication of the exact same test.

I have no idea why that code was duplicated with slightly different
syntax, but my OCD couldn't let it remain when I was editing those
lines.

              Linus
