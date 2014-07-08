Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaGHMHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:07:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59387 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaGHMHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:07:04 -0400
Date: Tue, 8 Jul 2014 05:07:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-man@vger.kernel.org
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Message-ID: <20140708120702.GB30459@infradead.org>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com>
 <CALCETrU=HLmw9n-DxPkFV1xP5wtzQ7-YF3-uao6YiGZODA9kdw@mail.gmail.com>
 <20140630154928.GB10375@google.com>
 <CALCETrWJ-rqDo8OvSZWPUt1806gObNtwVHvC4M6kfQgvd3Eg9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWJ-rqDo8OvSZWPUt1806gObNtwVHvC4M6kfQgvd3Eg9w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 08:53:01AM -0700, Andy Lutomirski wrote:
> > Wouldn't it need to be both O_BENEATH_ONLY (for openat()) and
> > AT_BENEATH_ONLY (for other *at() functions), like O_NOFOLLOW and
> > AT_SYMLINK_NOFOLLOW?  (I.e. aren't the AT_* flags in a different
> > numbering space than O_* flags?)
> >
> > Or am I misunderstanding?
> >
> 
> Ugh, you're probably right.  I wish openat had separate flags and
> atflags arguments.  Oh well.

There's two different AT_* namespaces.  The flags that most *at syscalls
has, and the the one for the dfd argument, which currently only contains
AT_FDCWD, although a new constant has recently been proposed to it.

Having an AT_BENEATH magic value for the dfd argument certainly feels
elegant to me, but seems to be against the language for openat in Posix:

"The openat() function shall be equivalent to the open() function except
in the case where path specifies a relative path. In this case the file
to be opened is determined relative to the directory associated with the
file descriptor fd instead of the current working directory. If the file
descriptor was opened without O_SEARCH, the function shall check whether
directory searches are permitted using the current permissions of the
directory underlying the file descriptor. If the file descriptor was
opened with O_SEARCH, the function shall not perform the check.

The oflag parameter and the optional fourth parameter correspond exactly
to the parameters of open().

If openat() is passed the special value AT_FDCWD in the fd parameter,
the current working directory shall be used and the behavior shall be
identical to a call to open()."

