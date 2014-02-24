Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaBXRtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:49:50 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:33044 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaBXRts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:49:48 -0500
MIME-Version: 1.0
In-Reply-To: <20140224171238.GG4026@tucsk.piliscsaba.szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
	<19258.1392306854@warthog.procyon.org.uk>
	<20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu>
	<20106.1392309770@warthog.procyon.org.uk>
	<CAJfpegtTDgLY=koYwg8m=snyD8FQ_EFyvLWErhcQ1jprAcOrrA@mail.gmail.com>
	<CA+55aFxE+v-RpHd1zNdw4COrkXmdT5btuE6Xei4oyeWSzeGHLw@mail.gmail.com>
	<16729.1392318161@warthog.procyon.org.uk>
	<CA+55aFyT9_XSFQwv82Qwv5US7QMOvW8RhbsxOa8B2mm3MChWLA@mail.gmail.com>
	<CAJfpegsDG-NoqvYog5PWqR=XOQgT0dSOTsjDwhd8v11T0kiEVA@mail.gmail.com>
	<20140224171238.GG4026@tucsk.piliscsaba.szeredi.hu>
Date: Mon, 24 Feb 2014 09:49:47 -0800
X-Google-Sender-Auth: 9zZsoqEcf18t36odHRpY3sz2SbA
Message-ID: <CA+55aFzCA4eE0+dnXHcOVpMKwxx425XzwBf-4pbcHF6JST321w@mail.gmail.com>
Subject: Re: [PATCH 00/13] cross rename v4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 9:12 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> This patch uses the 0/0 device number, but the actual number doesn't matter
> as long as it doesn't conflict with a real device.

Side note: I think 0/0 is the right choice, for a very specific
reason: it is already documented as being special. No other
combination has that.

We've had "major number 0" documented as being for unnamed devices,
and minor 0 is "reserved as null device number", which is just bad
documentation (it's *not* /dev/null, it doesn't exist). You cannot
register a character device with mijor/minor 0 in Linux, for example.

(The block layer similarly considers MKDEV(0,0) to be an unallocated device)

            Linus
