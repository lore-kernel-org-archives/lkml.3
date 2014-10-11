Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaJKMY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 08:24:56 -0400
Received: from mx1.polytechnique.org ([129.104.30.34]:36987 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaJKMYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 08:24:55 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Oct 2014 08:24:55 EDT
Message-ID: <54391F7C.1050001@m4x.org>
Date: Sat, 11 Oct 2014 14:15:56 +0200
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: always use the same type for __syscall_stub_start
References: <1413026981-9667-1-git-send-email-nicolas.iooss_linux@m4x.org> <54391792.40508@nod.at>
In-Reply-To: <54391792.40508@nod.at>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP at svoboda.polytechnique.org (Sat Oct 11 14:15:47 2014 +0200 (CEST))
X-Spam-Flag: No, tests=bogofilter, spamicity=0.050827, queueID=2DFA41408EEFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-11 13:42 GMT+02:00 Richard Weinberger:
> Am 11.10.2014 um 13:29 schrieb Nicolas Iooss:
>> syscall_stub_start is declared with different types in C files:
>>
>>   arch/um/kernel/physmem.c: extern int __syscall_stub_start;
>>   arch/um/kernel/skas/mmu.c: extern int __syscall_stub_start;
>>   arch/um/os-Linux/skas/mem.c: extern unsigned long __syscall_stub_start;
>>   arch/um/os-Linux/skas/process.c: extern int __syscall_stub_start;
>>
>> Fix this inconsistency by always using unsigned long.  This does not
>> change anything in the compiled code because only the address of
>> __syscall_stub_start is used, but it makes the static checker I use
>> stop complaining about incompatible declarations.
>
> While we're here, can you put these declarations into a single header
file?

Sure.  Do you have a specific header file in mind or shall I create
arch/um/include/asm/sections.h with declarations for
__syscall_stub_start, __syscall_stub_end and __binary_start (used in
arch/um/kernel/um_arch.c)?

Thanks for your quick reply,

Nicolas


