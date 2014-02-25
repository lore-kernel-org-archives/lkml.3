Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaBYEHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:07:17 -0500
Received: from mail05-md.ns.itscom.net ([175.177.155.115]:33629 "EHLO
	mail05-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaBYEHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:07:15 -0500
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH 00/13] cross rename v4
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
In-Reply-To: <20140224171238.GG4026@tucsk.piliscsaba.szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu> <19258.1392306854@warthog.procyon.org.uk> <20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu> <20106.1392309770@warthog.procyon.org.uk> <CAJfpegtTDgLY=koYwg8m=snyD8FQ_EFyvLWErhcQ1jprAcOrrA@mail.gmail.com> <CA+55aFxE+v-RpHd1zNdw4COrkXmdT5btuE6Xei4oyeWSzeGHLw@mail.gmail.com> <16729.1392318161@warthog.procyon.org.uk> <CA+55aFyT9_XSFQwv82Qwv5US7QMOvW8RhbsxOa8B2mm3MChWLA@mail.gmail.com> <CAJfpegsDG-NoqvYog5PWqR=XOQgT0dSOTsjDwhd8v11T0kiEVA@mail.gmail.com> <20140224171238.GG4026@tucsk.piliscsaba.szeredi.hu>
Date: Tue, 25 Feb 2014 13:07:10 +0900
Message-ID: <13532.1393301230@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> As Linus' suggestion, a whiteout is represented as a dummy char device.
> This patch uses the 0/0 device number, but the actual number doesn't matter
> as long as it doesn't conflict with a real device.

I have no objection about the char device.
But why do we need an inode for every whiteout? I'd suggest making a
hardlink. For some filesystems which don't support hardlinks, we have to
consume an inode per whiteout. But when the fs supports hardlinks, we
can re-use the inode and consume a few inodes only.


J. R. Okajima
