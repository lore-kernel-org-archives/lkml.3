Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaDONzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:55:17 -0400
Received: from mano-163-21-shared.jabatus.fr ([109.234.163.21]:47698 "EHLO
	mano-163-21-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbaDONzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:55:12 -0400
X-Greylist: delayed 714 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 09:55:12 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 2860E8F614E7.A1844
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D3757.3040800@manux.info>
Date: Tue, 15 Apr 2014 15:42:47 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][2/11][MANUX] Kernel compatibility : uname(2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, I would like to discuss syscalls.

As my kernel is binarily compatible with Linux, it implements the same
syscalls on the same vector (0x80, I've not yet implemented
sysenter-like things, and as mentionned earlier, it currently only
runs on x86/32). Of course, not all of them have been reimplemented
(keyctl(8), for example, proudly returns -ENOSYS), but the implemented
ones are faithfully following the Linux specification.

Well, nearly. That is, besides potential bugs (and unimplemented
features), I have done one notable modification, to the uname(2) syscall.

When I initially wrote my kernel, I ran into some trouble with the glibc
: it kept telling me that my kernel was too old. That's because, in its
Linux version, it checks that the kernel version number is at least
2.2.5 - without checking that the OS's *name* is actually "Linux". Thus,
when I answered "Manux, version 0.0.0", I never got anything working.

Of course, I could have proposed a patch to the glibc, but :
- This would have done nothing for statically-linked programs;
- In addition, it's highly likely other programs are doing similar
checks, and would have failed for a similar reason.

Thus, I decided to fake a Linux-like answer on this syscall, and
implement another syscall where I could put what I wanted. In practice,
I currently identify myself as "Linux 2.6.35" through uname(2), but
"Manux 0.0.5" through my uname_vect(2) syscall.

Is it okay to do this? Do you have any objections or remarks?

Thank you,

Emmanuel
