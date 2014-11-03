Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaKCRGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:06:55 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:52013 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaKCRGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:06:52 -0500
MIME-Version: 1.0
In-Reply-To: <20141103083447.GA8617@infradead.org>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
 <5452B241.5010603@amacapital.net> <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
 <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
 <CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
 <20141031084220.GA29085@infradead.org> <CALCETrXdPV5+qJ438Ky=tfBiEmqeeTYNuukQS7TcjbEwDgzwGQ@mail.gmail.com>
 <CA+55aFxUdjsm0gC0ULaOq_RhDLjWp=RDOE_O9qXdQRPqJUrZVA@mail.gmail.com> <20141103083447.GA8617@infradead.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 09:06:30 -0800
Message-ID: <CALCETrUjbfSiPUvTzTfOVAbxy5dy3PpKnnC+h4P_+FOeibTgDw@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Rannaud <e@nanocritical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 3, 2014 12:34 AM, "Christoph Hellwig" <hch@infradead.org> wrote:
>
> On Fri, Oct 31, 2014 at 11:53:09AM -0700, Linus Torvalds wrote:
> > On Fri, Oct 31, 2014 at 11:44 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > >
> > > Does the patch in this thread not fix that?
> >
> > It should. Modulo the glibc problem that makes it hard to actually set
> > the mode properly.
>
> That doesn't help because we explicitly reject O_RDONLY when combined
> with O_TMPFILE.

I think I'm missing something.  How is an O_RDONLY temporary file
useful?  Wouldn't you want an O_RDWR tempfile with mode 0400 or
something like that?

--Andy
