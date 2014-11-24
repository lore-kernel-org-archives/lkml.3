Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaKXRHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:07:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28751 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaKXRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:07:44 -0500
Date: Mon, 24 Nov 2014 20:06:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Drysdale <drysdale@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>,
        x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCHv10 2/5] x86: Hook up execveat system call.
Message-ID: <20141124170626.GA5316@mwanda>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-3-git-send-email-drysdale@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416830039-21952-3-git-send-email-drysdale@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 11:53:56AM +0000, David Drysdale wrote:
> Hook up x86-64, i386 and x32 ABIs.
> 
> Signed-off-by: David Drysdale <drysdale@google.com>

This one has been breaking my linux-next build for the past week.  I'm
not sure what's going on.  I build with a script:

make allmodconfig

cat << EOF >> .config
CONFIG_DYNAMIC_DEBUG=n
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=n
CONFIG_DYNAMIC_DEBUG=y
EOF

make oldconfig

Here are the errors:

  CHK     include/generated/compile.h
  CHECK   arch/x86/ia32/audit.c
  CC      arch/x86/ia32/audit.o
arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [arch/x86/ia32/audit.o] Error 1
make[2]: Target `__build' not remade because of errors.
make[1]: *** [arch/x86/ia32] Error 2
  CHECK   arch/x86/kernel/audit_64.c
  CHK     kernel/config_data.h
  CC      arch/x86/kernel/audit_64.o
arch/x86/kernel/audit_64.c: In function ‘audit_classify_syscall’:
arch/x86/kernel/audit_64.c:53:7: error: ‘__NR_execveat’ undeclared (first use in this function)
arch/x86/kernel/audit_64.c:53:7: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [arch/x86/kernel/audit_64.o] Error 1
make[2]: Target `__build' not remade because of errors.
make[1]: *** [arch/x86/kernel] Error 2
make[1]: Target `__build' not remade because of errors.

regards,
dan carpenter
