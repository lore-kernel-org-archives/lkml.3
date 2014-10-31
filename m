Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbaJaSpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:45:10 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:40589 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316AbaJaSpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:45:07 -0400
MIME-Version: 1.0
In-Reply-To: <20141031084220.GA29085@infradead.org>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
 <5452B241.5010603@amacapital.net> <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
 <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
 <CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com> <20141031084220.GA29085@infradead.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 31 Oct 2014 11:44:43 -0700
Message-ID: <CALCETrXdPV5+qJ438Ky=tfBiEmqeeTYNuukQS7TcjbEwDgzwGQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Rannaud <e@nanocritical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 31, 2014 1:42 AM, "Christoph Hellwig" <hch@infradead.org> wrote:
>
> On Thu, Oct 30, 2014 at 05:01:30PM -0700, Andy Lutomirski wrote:
> > > flink()), the mode really matters. So this idiotic glibc behavior of
> > > only forwarding the third argument if O_CREAT is set seems to be a
> > > bug.
> >
> > We could bite the bullet and add a tmpfile syscall.   /me ducks
>
> I've got another use case for that:  Samba.  It wants to inherit
> all kinds of attributes (xattrs, modes, etc) during file creation,
> and right now it's doing it in a racy way.  I've come up with a patch
> to use O_TEMPFILE + flink, but it turns out that Samba may as well
> be asked to create read-only files, which we can't create using
> O_TMPFILE.

Does the patch in this thread not fix that?
