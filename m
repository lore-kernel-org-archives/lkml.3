Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3A1CpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 21:45:08 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:48812 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3A1CpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 21:45:06 -0500
MIME-Version: 1.0
X-Originating-IP: [58.137.88.101]
In-Reply-To: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com>
References: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com>
Date: Mon, 28 Jan 2013 09:45:03 +0700
X-Google-Sender-Auth: 4z-hSkBfk7WO4xaukdCRKwsQxK8
Message-ID: <CACiLriS8TS0fA8VXG0gcS4hq-MAK2+zctqMjg=s0iG7m2YGB1Q@mail.gmail.com>
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 7:50 PM, Matthias Brugger
<matthias.bgg@gmail.com> wrote:
> This patch adds dummy syscalls so that compiling
> for this architecture does not provoke warnings when
> checksyscalls.sh is called.

Nice, but...

> --- a/arch/avr32/kernel/syscall_table.S
> +++ b/arch/avr32/kernel/syscall_table.S
> @@ -298,3 +298,32 @@ sys_call_table:
>         .long   sys_recvmmsg
>         .long   sys_setns
>         .long   sys_ni_syscall          /* r8 is saturated at nr_syscalls */

This terminator needs to stay at the end. Its only purpose is to allow
us to save a cycle or two when saturating the system call number.

Also, Al's suggestion sounds good to me.

Havard
