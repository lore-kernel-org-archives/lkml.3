Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaAOP3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:29:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50263 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbaAOP3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:29:36 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140115133838.GD8101@stro.at>
References: <1389791824.17407.9.camel@x220> <20140115133838.GD8101@stro.at>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] kexec.h: stop exporting kexec_load() to userspace
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 15 Jan 2014 07:28:32 -0800
To: Maximilian Attems <max@stro.at>, Paul Bolle <pebolle@tiscali.nl>
CC: Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <9bb7c8e9-95e7-4819-b295-3ee24c9e9b3b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't put prototypes of user-space functions in the kernel, at least not until we actually export all the signatures.  The prototype should instead be in a userspace <sys/kexec.h> header.

Maximilian Attems <max@stro.at> wrote:
>
>On Wed, Jan 15, 2014 at 02:17:04PM +0100, Paul Bolle wrote:
>> Since v3.5 kexec.h is exported to userspace. That includes its
>> declaration of kexec_load():
>>     extern int kexec_load(void *, size_t, struct kexec_segment *,
>>                    unsigned long int);
>> 
>> This declaration isn't very useful to userspace programs on itself.
>They
>> still have to define a matching function (which basically wraps the
>> kexec_load syscall). I'm not aware of programs or libraries that
>actually
>> do that.
>> 
>> It can be removed. The programs that actually use it, if there
>> are any, should then provide their own declaration to keep compiling.
>> Already compiled binaries will not be affected.
>
>nack, klibc uses the header and there was some discussion that glibc
>could/should use it too. I didn't follow kexec git, but there is/was
>a version that just uses the kexec_load() if the c library provides it.
>Until Santa Claus materialises in form of a direct kernel user-space
>API,
>see follow ups on http://lwn.net/Articles/534682/ and proposal by hpa
> 
>> This gets rid of the headers_check warning that can be seen ever
>since
>> this header was exported:
>>     [...]/usr/include/linux/kexec.h:49: userspace cannot reference
>function or variable defined in the kernel
>> 
>
>this is the wrong  way of fix.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
