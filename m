Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbaD3QfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:35:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51682 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaD3QfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:35:18 -0400
Message-ID: <53612634.2070802@zytor.com>
Date: Wed, 30 Apr 2014 09:35:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Kettenis <mark.kettenis@xs4all.nl>
CC: pinskia@gmail.com, teawater@gmail.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, eparis@redhat.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, gdb@sourceware.org
Subject: Re: [PATCH] Fix get ERESTARTSYS with m32 in x86_64 when debug by
 GDB
References: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com>	<53554846.3070608@zytor.com>	<CANFwon3zA9FMujmnN3nMiv8Zr8bU9o72XXa26dkePNq57U=JcQ@mail.gmail.com>	<53608125.2020103@zytor.com> <CA+=Sn1=y-smZOaD_yRxEwgu-PPaZYdQtB_RGPCA5-9wmB6=hvQ@mail.gmail.com> <536085B7.5070002@zytor.com> <201404301335.s3UDZX4J017978@glazunov.sibelius.xs4all.nl>
In-Reply-To: <201404301335.s3UDZX4J017978@glazunov.sibelius.xs4all.nl>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 06:35 AM, Mark Kettenis wrote:
> 
> If (and only if) the goal of that TS_COMPAT flag solely is to trigger
> the error code sign-extension in arch/x86/asm/syscall.h:syscall_get_error(),
> we could work around to problem in GDB by checking "orig_ax" to see if
> we're continuing an interrupted system call and sign extend the error
> code in the real "eax" register if we are.
> 

Well... this "if and only if" clause is false, although it might work
specifically in this context.  I need to do a writeup about this... I
should try to do that today.

	-hpa

