Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbaFKPV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:21:57 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:56535 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaFKPV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:21:56 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4C4pvFyQyqiGLRpJqp=RF+3q7=aMs_KKnzS1=VU5ojsQ@mail.gmail.com>
References: <CA+5PVA4srNrj2xqMYH40N13rV+jC-PbLdyNpoURomTq48cJNBA@mail.gmail.com>
 <CA+5PVA7gL6T2eXAy6G4hGJzhKZ_8KHd0qauKqzuHAP4oTJ97QA@mail.gmail.com>
 <5398732E.2060900@zytor.com> <CA+5PVA4C4pvFyQyqiGLRpJqp=RF+3q7=aMs_KKnzS1=VU5ojsQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 11 Jun 2014 08:21:35 -0700
Message-ID: <CALCETrX4Rq_3BAN=CKWwc2KMSGnz1HkLWtSW0A1zqQ9FHzKNUw@mail.gmail.com>
Subject: Re: vdso_install target broken post-3.15
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 8:20 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Wed, Jun 11, 2014 at 11:18 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/11/2014 08:16 AM, Josh Boyer wrote:
>>> On Wed, Jun 11, 2014 at 10:14 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>>>> Hi,
>>>>
>>>> I'm guessing commit 6f121e548f83674ab4920a4e60afb58d4f61b829 is what
>>>> broke the vdso_install target:
>>>>
>>>> + make -s ARCH=x86_64
>>>> INSTALL_MOD_PATH=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.16.0-0.rc0.git1.1.fc21.x86_64
>>>> vdso_install KERNELRELEASE=3.16.0-0.rc0.git1.1.fc21.x86_64
>>>> make[1]: *** No rule to make target `arch/x86/vdso/vdso.so.dbg',
>>>> needed by `vdso.so'.  Stop.
>>>> make: *** [vdso_install] Error 2
>>>>
>>>> The crazy Fedora versioning there corresponds to
>>>> 3f17ea6dea8ba5668873afa54628a91aaa3fb1c0 in Linus' tree.  I'll poke at
>>>> this some, but if you have some quick ideas I'd be happy to try them.
>>>
>>> OK, I'm stumped.  Looking at that commit, it removes all target
>>> invocations for vdso.so.  Which means even a simple 'make' in the vdso
>>> directory fails with:
>>>
>>> [jwboyer@vader vdso]$ make
>>> make: *** No rule to make target `/vdso.so', needed by `/vdso.o'.  Stop.
>>> [jwboyer@vader vdso]$
>>>
>>> So how was this commit build tested?
>>>
>>
>> Since when do we support "make" in a subdirectory?
>
> Dunno.  Since when do we break existing make targets that worked fine?
>

make in a subdirectory like that (and the vdso directory in
particular) is amazingly glitchy.  I think it's lucky it used to work
like that.

> Seriously, I'm just asking how this was build tested so I can try and
> duplicate that and then figure out how to fix the actual bug.

cd ../../..; make  :)

I'll race you to trying to fix it.

--Andy
