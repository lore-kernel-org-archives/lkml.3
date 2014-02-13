Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaBMS3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:29:22 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:45549 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaBMS3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:29:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAJfpegtTDgLY=koYwg8m=snyD8FQ_EFyvLWErhcQ1jprAcOrrA@mail.gmail.com>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
	<19258.1392306854@warthog.procyon.org.uk>
	<20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu>
	<20106.1392309770@warthog.procyon.org.uk>
	<CAJfpegtTDgLY=koYwg8m=snyD8FQ_EFyvLWErhcQ1jprAcOrrA@mail.gmail.com>
Date: Thu, 13 Feb 2014 10:29:19 -0800
X-Google-Sender-Auth: mZhT7cWcCdx-2cOS2J313cNZOXM
Message-ID: <CA+55aFxE+v-RpHd1zNdw4COrkXmdT5btuE6Xei4oyeWSzeGHLw@mail.gmail.com>
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

On Thu, Feb 13, 2014 at 9:28 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> I would suggest that whiteouts appear as otherwise negative dentries and that
>> they don't appear in getdents().
>
> I'd argue that this is an administration nightmare.  E.g. what if the
> a backup needs to be made of the rw layer?

The major issue is user space support.

So what do others that support this do?  Looking at the gitweb for
ls.c in coreutils, we find:

http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=blob;f=src/ls.c

    # ifdef DT_WHT
                    case DT_WHT:  type = whiteout;          break;
    # endif

so that's presumably what we should use.

                     Linus
