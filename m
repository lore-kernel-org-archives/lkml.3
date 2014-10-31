Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbaJaIm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:42:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55171 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbaJaImY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:42:24 -0400
Date: Fri, 31 Oct 2014 01:42:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Rannaud <e@nanocritical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
Message-ID: <20141031084220.GA29085@infradead.org>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
 <5452B241.5010603@amacapital.net>
 <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
 <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
 <CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 05:01:30PM -0700, Andy Lutomirski wrote:
> > flink()), the mode really matters. So this idiotic glibc behavior of
> > only forwarding the third argument if O_CREAT is set seems to be a
> > bug.
> 
> We could bite the bullet and add a tmpfile syscall.   /me ducks

I've got another use case for that:  Samba.  It wants to inherit
all kinds of attributes (xattrs, modes, etc) during file creation,
and right now it's doing it in a racy way.  I've come up with a patch
to use O_TEMPFILE + flink, but it turns out that Samba may as well
be asked to create read-only files, which we can't create using
O_TMPFILE.
