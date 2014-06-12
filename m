Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaFLSGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:06:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaFLSGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:06:20 -0400
Date: Thu, 12 Jun 2014 20:05:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Pedro Alves <palves@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, hpa@zytor.com, suresh.b.siddha@intel.com
Subject: Re: [PATCH v2] ptrace: Clarify PTRACE_GETREGSET/PTRACE_SETREGSET,
	documentation in uapi header
Message-ID: <20140612180501.GB15795@redhat.com>
References: <1398682853-7541-1-git-send-email-khandual@linux.vnet.ibm.com> <53625681.8010905@redhat.com> <53670F35.6010502@linux.vnet.ibm.com> <53725FF6.6060004@redhat.com> <537316DB.4060701@linux.vnet.ibm.com> <53734B7D.4010504@redhat.com> <53996A20.3030300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53996A20.3030300@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12, Anshuman Khandual wrote:
>
> > --- a/include/uapi/linux/ptrace.h
> > +++ b/include/uapi/linux/ptrace.h
> > @@ -39,12 +39,17 @@
> >   * payload are exactly the same layout.
> >   *
> >   * This interface usage is as follows:
> > - *	struct iovec iov = { buf, len};
> > + *	struct iovec iov = { buf, len };
> >   *
> >   *	ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
> >   *
> > - * On the successful completion, iov.len will be updated by the kernel,
> > - * specifying how much the kernel has written/read to/from the user's iov.buf.
> > + * On entry, iov describes the buffer's address and length.  The buffer's length
> > + * must be a multiple of the size of a single register in the register set.  The
> > + * kernel never reads or writes more than iov.len, and caps the buffer length to
> > + * the register set's size.  In other words, the kernel reads or writes
> > + * min(iov.len, regset size).

I think this should be self-obvious ;) otherwise why do we need to pass
the length of the buffer?

But of course I won't argue with the additional documentation, perhaps you
can re-send this patch to akpm? Usually ptrace changes are routed via -mm
tree.

But if we update the kernel header, then probably it would be more important
to update the man-page. To me the description of GETREGSET looks good, but
probably it could also mention that buflen should be multiple of regsize (as
you did above). Add Michael.

Oleg.

