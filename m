Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaJUEab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:30:31 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:42536 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaJUEa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:30:27 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzqUsdjyE4ZHLyKwCm-SsV4NvFNyy7FTpROTg-J9+kZmg@mail.gmail.com>
References: <CAPM=9tyZF2S7PJcLyc=KH_NBFXju8UwvMBOF_MocNK8pPVXDYw@mail.gmail.com>
	<20140912112619.50d3b651@www.etchedpixels.co.uk>
	<CAPM=9tzuHQxPYoUZegKzwUoHBvp1UTkmtV3zcBmUxeJUr9qAWA@mail.gmail.com>
	<CA+55aFzqUsdjyE4ZHLyKwCm-SsV4NvFNyy7FTpROTg-J9+kZmg@mail.gmail.com>
Date: Tue, 21 Oct 2014 14:30:25 +1000
Message-ID: <CAPM=9tzj7hAC9syi6Mqf3Gz1=T5VksQFBsVLiFmiZ6CM5_34vg@mail.gmail.com>
Subject: Re: vga and 64-bit memcpy's
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 September 2014 01:11, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Sep 12, 2014 at 3:48 AM, Dave Airlie <airlied@gmail.com> wrote:
>>
>> Well I'm not shocked that an SMI GPU is out of spec, just not sure how
>> we can workaround it.
>
> Try just removing the
>
>   #define scr_memcpyw(d, s, c) memcpy(d, s, c)
>   #define VT_BUF_HAVE_MEMCPYW
>
> (and perhaps MEMMOVEW case too) from the default implementation, and
> see if doing things 16-bit words at a time using the fallbacks ends up
> working. As Alan said, write combining might defeat that, but quite
> frankly, we already do this for the MEMSETW case (probably because we
> forgot, possibly because it's not as performance-sensitive)
>
> My gut feel is that we don't care deeply about performance here,
> because (a) true text-modes are less common anyway and (b) true text
> modes are pretty damn fast anyway compared to the more usual "write
> the whole glyph as graphics" fbcon case.
>
> And *maybe* it works. And maybe that SMI GPU is a piece of shit that
> isn't worth worrying about in VGA text-mode. Where the hell are they
> found anyway?

Sorry I let this fall off the planet,

some huawei x86 server has this behaviour, works with RHEL5 32-bit,
fails with RHEL6 64-bit.

//#define scr_memcpyw(d, s, c) memcpy(d, s, c)
//#define scr_memmovew(d, s, c) memmove(d, s, c)
//#define VT_BUF_HAVE_MEMCPYW
//#define VT_BUF_HAVE_MEMMOVEW
was tested and found to work, just a question if we care enough to fix
it I suppose.

Dave.





The info I have
>
>                Linus
