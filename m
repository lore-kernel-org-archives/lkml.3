Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaBOW7x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 17:59:53 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:42124 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaBOW7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 17:59:51 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz6feRh9+U7OY6C4CfNe68CqQZARCf_J9deJdsUUG_ryg@mail.gmail.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com>
	<87ob28kqks.fsf_-_@xmission.com>
	<87bny8kqik.fsf_-_@xmission.com>
	<CA+55aFz6feRh9+U7OY6C4CfNe68CqQZARCf_J9deJdsUUG_ryg@mail.gmail.com>
Date: Sat, 15 Feb 2014 14:59:50 -0800
X-Google-Sender-Auth: H4EkUgCoSPKubDikq6RKGe48gew
Message-ID: <CA+55aFzfa3=ukGq=XJbxj-xqud32DvbF7AcroBKL6-GY32or7Q@mail.gmail.com>
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

On Sat, Feb 15, 2014 at 2:51 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> the whole check_submounts_and_drop thing walks the parent chain and
> locks each parent with the renamelock held for writing.

Oops, my bad about the write lock, brainfart due to grepping and
reading the wrong context...

check_submounts_and_drop() doesn't do the parent walk with the rename
lock held for writing, it just holds it for reading.

But it does do that very complex "walk parents and check all siblings"
and locks them, so the rest of the commentary was correct.

                Linus
