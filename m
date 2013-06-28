Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3F1UJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:09:30 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:37049 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3F1UJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:09:27 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
Date: Fri, 28 Jun 2013 22:09:21 +0200
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        David Daney <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mips@linux-mips.org, stable@vger.kernel.org
References: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com> <20130626161452.GA2888@redhat.com> <20130626165900.GF7171@linux-mips.org>
In-Reply-To: <20130626165900.GF7171@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201306282209.21839.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 June 2013 18:59, Ralf Baechle wrote:
> On Wed, Jun 26, 2013 at 06:14:52PM +0200, Oleg Nesterov wrote:
> 
> > Or simply remove the BUG_ON(), this can equally confuse wait(status).
> > 128 & 0x7f == 0.
> > 
> > Still I think it would be better to change _NSIG on mips.
> 
> If it was that easy.  That's going to outright break binary compatibility,
> see kernel/signal.c:
> 
> SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, nset,
>                 sigset_t __user *, oset, size_t, sigsetsize)
> {
>         sigset_t old_set, new_set;
>         int error;
> 
>         /* XXX: Don't preclude handling different sized sigset_t's.  */
>         if (sigsetsize != sizeof(sigset_t))
>                 return -EINVAL;
> 
> There are several more more syscalls performing tests like the above.

Reducing _NSIG to 127 (or 126) doesn't change sigset_t, so should be fine wrt above.
