Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3KFV0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:26:54 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:37577 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab3KFV0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:26:52 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9hbaZhAztYF_H8RTuTdhh+J4WHaGpdRLR3EqHbtH2OLU+Q@mail.gmail.com>
References: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com>
	<1383751951.28218.64.camel@flatline.rdu.redhat.com>
	<20131106155104.GZ16735@n2100.arm.linux.org.uk>
	<CABqD9hbaZhAztYF_H8RTuTdhh+J4WHaGpdRLR3EqHbtH2OLU+Q@mail.gmail.com>
Date: Wed, 6 Nov 2013 13:26:52 -0800
X-Google-Sender-Auth: Xx4GB0uICkzUy85LdN_10OHOnbo
Message-ID: <CAGXu5jLr3G+n3SRrpJOZbHsdY76dN34TNP0arL2_FyBg7c2EAg@mail.gmail.com>
Subject: Re: [libseccomp-discuss] ARM audit, seccomp, etc are broken wrt OABI syscalls
From: Kees Cook <keescook@chromium.org>
To: Will Drewry <wad@chromium.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        libseccomp-discuss@lists.sourceforge.net,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 1:20 PM, Will Drewry <wad@chromium.org> wrote:
> On Wed, Nov 6, 2013 at 9:51 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Wed, Nov 06, 2013 at 10:32:31AM -0500, Eric Paris wrote:
>>> On Tue, 2013-11-05 at 14:36 -0800, Andy Lutomirski wrote:
>>> > 1. Set a different audit arch for OABI syscalls (e.g.
>>> > AUDIT_ARCH_ARMOABI).  That is, treat OABI syscall entries the same way
>>> > that x86_64 treats int 80.
>>>
>>> As the audit maintainer, I like #1.  It might break ABI, but the ABI is
>>> flat wrong now and not maintainable...
>>
>> If you read the whole thread, you will see that this corner case is just
>> not worth the effort to support.  Audit may as well be disabled by
>> kernel config if any OABI support is enabled.
>
> This might be the best move for seccomp too (as Kees suggested).  I'd
> love to have audit arch visibility, but it's not clear that it's worth
> any sort of larger changes ...
>
> ... like adding a task_thread_info.compat flag that bubbles up to
> syscall_get_arch(), or if we assume consumers of syscall_get_nr() are
> broken today (I haven't checked), then it would be possible to at
> least re-add the 0x900000 bits, if compat, before handing back the
> system call number but leave the audit arch pieces alone.

How does this look, for the seccomp part?

-Kees

diff --git a/arch/Kconfig b/arch/Kconfig
index af2cc6eabcc7..3610c2d9910f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -331,7 +331,7 @@ config HAVE_ARCH_SECCOMP_FILTER

 config SECCOMP_FILTER
        def_bool y
-       depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET
+       depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET && !OABI_COMPAT
        help
          Enable tasks to build secure computing environments defined
          in terms of Berkeley Packet Filter programs which implement


-- 
Kees Cook
Chrome OS Security
