Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaBPAD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 19:03:56 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:56607 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaBPADy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 19:03:54 -0500
MIME-Version: 1.0
In-Reply-To: <87a9ds55av.fsf@xmission.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com>
	<87ob28kqks.fsf_-_@xmission.com>
	<87bny8kqik.fsf_-_@xmission.com>
	<CA+55aFz6feRh9+U7OY6C4CfNe68CqQZARCf_J9deJdsUUG_ryg@mail.gmail.com>
	<CA+55aFzfa3=ukGq=XJbxj-xqud32DvbF7AcroBKL6-GY32or7Q@mail.gmail.com>
	<87a9ds55av.fsf@xmission.com>
Date: Sat, 15 Feb 2014 16:03:53 -0800
X-Google-Sender-Auth: e_cqroyEPYq1bb4FB6V1A1DfEx8
Message-ID: <CA+55aFyQntJjtVDJ1BsWGaPA5YY96ZjWJSxz-unjWU-RaQiFjw@mail.gmail.com>
Subject: Re: [PATCH 02/11] vfs: More precise tests in d_invalidate
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 3:23 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Except that today d_invalidate drops the dcache lock and
> calls shrink_dcache_parent.  Which gets you into exactly the same
> complex "walk parents and check all siblings" code.

Hmm. It only does that for directories that have sub-entries, though.

I think you may care just about directories (because that's what your
series is about), but d_invalidate() is used for other cases too,
notably d_revalidate() (ie things like stale NFS lookups of normal
files).

That said, I'll have to think about this more. If d_subdir is empty, I
guess d_walk() will be fairly cheap. It's very different, but maybe
not as disastrous as I thought.

                Linus
