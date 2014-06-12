Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaFLStm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:49:42 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:57315 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaFLStj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:49:39 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140612180501.GB15795@redhat.com>
References: <1398682853-7541-1-git-send-email-khandual@linux.vnet.ibm.com>
 <53625681.8010905@redhat.com> <53670F35.6010502@linux.vnet.ibm.com>
 <53725FF6.6060004@redhat.com> <537316DB.4060701@linux.vnet.ibm.com>
 <53734B7D.4010504@redhat.com> <53996A20.3030300@linux.vnet.ibm.com> <20140612180501.GB15795@redhat.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 12 Jun 2014 20:49:18 +0200
Message-ID: <CAKgNAkjj=LnYSLrpteTjv+EcxVDQgObDkxCMgH-z4TQWZ=N3SQ@mail.gmail.com>
Subject: Re: [PATCH v2] ptrace: Clarify PTRACE_GETREGSET/PTRACE_SETREGSET,
 documentation in uapi header
To: Oleg Nesterov <oleg@redhat.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Pedro Alves <palves@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        suresh.b.siddha@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 8:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/12, Anshuman Khandual wrote:
>>
>> > --- a/include/uapi/linux/ptrace.h
>> > +++ b/include/uapi/linux/ptrace.h
>> > @@ -39,12 +39,17 @@
>> >   * payload are exactly the same layout.
>> >   *
>> >   * This interface usage is as follows:
>> > - * struct iovec iov = { buf, len};
>> > + * struct iovec iov = { buf, len };
>> >   *
>> >   * ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
>> >   *
>> > - * On the successful completion, iov.len will be updated by the kernel,
>> > - * specifying how much the kernel has written/read to/from the user's iov.buf.
>> > + * On entry, iov describes the buffer's address and length.  The buffer's length
>> > + * must be a multiple of the size of a single register in the register set.  The
>> > + * kernel never reads or writes more than iov.len, and caps the buffer length to
>> > + * the register set's size.  In other words, the kernel reads or writes
>> > + * min(iov.len, regset size).
>
> I think this should be self-obvious ;) otherwise why do we need to pass
> the length of the buffer?
>
> But of course I won't argue with the additional documentation, perhaps you
> can re-send this patch to akpm? Usually ptrace changes are routed via -mm
> tree.
>
> But if we update the kernel header, then probably it would be more important
> to update the man-page. To me the description of GETREGSET looks good, but
> probably it could also mention that buflen should be multiple of regsize (as
> you did above). Add Michael.

Can someone send a patch, then?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
