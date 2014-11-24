Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaKXS4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:56:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:40740 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaKXS4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:56:52 -0500
Date: Mon, 24 Nov 2014 19:53:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: David Drysdale <drysdale@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>,
        x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCHv10 2/5] x86: Hook up execveat system call.
In-Reply-To: <20141124170626.GA5316@mwanda>
Message-ID: <alpine.DEB.2.11.1411241950020.6439@nanos>
References: <1416830039-21952-1-git-send-email-drysdale@google.com> <1416830039-21952-3-git-send-email-drysdale@google.com> <20141124170626.GA5316@mwanda>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1221348284-1416855184=:6439"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1221348284-1416855184=:6439
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 24 Nov 2014, Dan Carpenter wrote:

> On Mon, Nov 24, 2014 at 11:53:56AM +0000, David Drysdale wrote:
> > Hook up x86-64, i386 and x32 ABIs.
> > 
> > Signed-off-by: David Drysdale <drysdale@google.com>
> 
> This one has been breaking my linux-next build for the past week.  I'm
> not sure what's going on.  I build with a script:
> 
> make allmodconfig
> 
> cat << EOF >> .config
> CONFIG_DYNAMIC_DEBUG=n
> CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=n
> CONFIG_DYNAMIC_DEBUG=y
> EOF
> 
> make oldconfig
> 
> Here are the errors:
> 
>   CHK     include/generated/compile.h
>   CHECK   arch/x86/ia32/audit.c
>   CC      arch/x86/ia32/audit.o
> arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
> arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
> arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
> make[2]: *** [arch/x86/ia32/audit.o] Error 1
> make[2]: Target `__build' not remade because of errors.
> make[1]: *** [arch/x86/ia32] Error 2
>   CHECK   arch/x86/kernel/audit_64.c
>   CHK     kernel/config_data.h
>   CC      arch/x86/kernel/audit_64.o
> arch/x86/kernel/audit_64.c: In function ‘audit_classify_syscall’:
> arch/x86/kernel/audit_64.c:53:7: error: ‘__NR_execveat’ undeclared (first use in this function)
> arch/x86/kernel/audit_64.c:53:7: note: each undeclared identifier is reported only once for each function it appears in
> make[2]: *** [arch/x86/kernel/audit_64.o] Error 1
> make[2]: Target `__build' not remade because of errors.
> make[1]: *** [arch/x86/kernel] Error 2
> make[1]: Target `__build' not remade because of errors.

I don't know what you're doing.

Tried the above and it rebuilds the relevant unistd*.h files and
compiles happily.

Thanks,

	tglx
--8323329-1221348284-1416855184=:6439--
