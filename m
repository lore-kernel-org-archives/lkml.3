Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaBKRyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:54:20 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:36316 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaBKRyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:54:18 -0500
MIME-Version: 1.0
In-Reply-To: <20140211160302.GA18936@infradead.org>
References: <20140211160302.GA18936@infradead.org>
Date: Tue, 11 Feb 2014 09:54:17 -0800
X-Google-Sender-Auth: P_tygE8Yb6J8uqtYtTjeuBT8Y0o
Message-ID: <CA+55aFy5qCfbr59-7X-EwoS4FpbH65tjhzMdnzSQ3AW5TsRPWw@mail.gmail.com>
Subject: Re: O_TMPFILE detection
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-man@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 8:03 AM, Christoph Hellwig <hch@infradead.org> wrote:
> I've started implementing support for O_TMPFILE in xfs_io in preparation
> for proper testcases and found something rather annoying:
>
> Given that we implicitly pass O_DIRECTORY as part of the full O_TMPFILE
> flag an open using O_TMPFILE will simply succeed on a kernel old enough
> to not have O_TMPFILE support, and give you a file descriptor for the
> directory passed in.  Of course this only works if you open the fd
> read-only which isn't all that useful for real temporary files, but it
> would be the natural choice for a feature test.

But O_TMPFILE without write access fails on modern kernels, so what
you test doesn't make sense.

In fact, that "O_TMPFILE fails with O_RDONLY" was done exactly so that
you could not have a program that works on kernels with O_TMPFILE
support _and_ opens a directory on old kernels without it. Basically
"O_TMPFILE | O_RDONLY" is an insane thing to do, and will never create
a temporary file.

              Linus
