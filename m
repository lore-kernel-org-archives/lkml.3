Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaARGuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 01:50:00 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52259 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbaARGtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 01:49:31 -0500
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20140117220858.GA31416@fieldses.org>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
	<1389219015-10980-12-git-send-email-miklos@szeredi.hu>
	<20140113122517.GA10366@quack.suse.cz>
	<20140115182347.GB5715@fieldses.org>
	<CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>
	<20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>
	<52D90B93.5010209@gmail.com>
	<20140117220858.GA31416@fieldses.org>
Date: Sat, 18 Jan 2014 07:49:29 +0100
Message-ID: <CAJfpegsW+zTvZZ_k+Wd=FOi0VqANGQHdS_2qSPWWLiXA0K_JJw@mail.gmail.com>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 11:08 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Fri, Jan 17, 2014 at 11:53:07PM +1300, Michael Kerrisk (man-pages) wrote:
>> >        The following additional errors are defined for renameat2():
>> >
>> >        EOPNOTSUPP
>> >               The filesystem does not support a flag in flags
>>
>> This is not the usual error for an invalid bit flag. Please make it EINVAL.
>
> I agree that EINVAL makes sense for an invalid bit flag.
>
> But renameat2() can also fail when the caller passes a perfectly valid
> flags field but the paths resolve to a filesystem that doesn't support
> the RENAME_EXCHANGE operation.  EOPNOTSUPP looks more appropriate in
> that case.

OTOH, from the app's perspective, it makes little difference whether a
particular kernel doesn't support the reanameat2 syscall, or it
doesn't support RENAME_FOO flag or if it does support RENAME_FOO but
not in all filesystems.  In all those cases it has to just fall back
to something supported and it doesn't matter *why* it wasn't
supported.

Thanks,
Miklos
