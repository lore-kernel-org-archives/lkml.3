Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaILPLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:11:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56321 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaILPLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:11:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzuHQxPYoUZegKzwUoHBvp1UTkmtV3zcBmUxeJUr9qAWA@mail.gmail.com>
References: <CAPM=9tyZF2S7PJcLyc=KH_NBFXju8UwvMBOF_MocNK8pPVXDYw@mail.gmail.com>
	<20140912112619.50d3b651@www.etchedpixels.co.uk>
	<CAPM=9tzuHQxPYoUZegKzwUoHBvp1UTkmtV3zcBmUxeJUr9qAWA@mail.gmail.com>
Date: Fri, 12 Sep 2014 08:11:07 -0700
X-Google-Sender-Auth: -eOw3NVE7qM2m8hdrd6Ice26ik0
Message-ID: <CA+55aFzqUsdjyE4ZHLyKwCm-SsV4NvFNyy7FTpROTg-J9+kZmg@mail.gmail.com>
Subject: Re: vga and 64-bit memcpy's
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 3:48 AM, Dave Airlie <airlied@gmail.com> wrote:
>
> Well I'm not shocked that an SMI GPU is out of spec, just not sure how
> we can workaround it.

Try just removing the

  #define scr_memcpyw(d, s, c) memcpy(d, s, c)
  #define VT_BUF_HAVE_MEMCPYW

(and perhaps MEMMOVEW case too) from the default implementation, and
see if doing things 16-bit words at a time using the fallbacks ends up
working. As Alan said, write combining might defeat that, but quite
frankly, we already do this for the MEMSETW case (probably because we
forgot, possibly because it's not as performance-sensitive)

My gut feel is that we don't care deeply about performance here,
because (a) true text-modes are less common anyway and (b) true text
modes are pretty damn fast anyway compared to the more usual "write
the whole glyph as graphics" fbcon case.

And *maybe* it works. And maybe that SMI GPU is a piece of shit that
isn't worth worrying about in VGA text-mode. Where the hell are they
found anyway?

               Linus
