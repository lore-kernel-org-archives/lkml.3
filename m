Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaFKRpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:45:43 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39953 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaFKRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:45:40 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXNLTL_VGo-epSdGY9ApXsmo_HLx90ncSsG1o18SmGTMg@mail.gmail.com>
References: <5398749B.4090209@zytor.com>
	<cover.1402503408.git.luto@amacapital.net>
	<fe51e9f5c338d33b1a8b20813441538df5e17add.1402503408.git.luto@amacapital.net>
	<CA+5PVA5uPj0JiTLXJAtBt9b9e6aEcJh7ApFRbaCAP0=se89GKA@mail.gmail.com>
	<53989190.9010806@zytor.com>
	<CA+5PVA7_B20q6mzq9yrbcQZEw0Z785pOCFeuTjKo7_9tn4_EsA@mail.gmail.com>
	<CALCETrXNLTL_VGo-epSdGY9ApXsmo_HLx90ncSsG1o18SmGTMg@mail.gmail.com>
Date: Wed, 11 Jun 2014 13:45:40 -0400
X-Google-Sender-Auth: pqk7v8r-NolrqsP3CHDs_AC892I
Message-ID: <CA+5PVA6ohJ3JpSptk7m629aoLjxh9zfYQ459-HPeggFpE0fFvA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86,vdso: Fix vdso_install
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 1:42 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Jun 11, 2014 at 10:33 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> On Wed, Jun 11, 2014 at 1:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 06/11/2014 10:23 AM, Josh Boyer wrote:
>>>>
>>>> So this does fix the invocation of 'make vdso_install' and the
>>>> resulting files look to be accurate to me, with the glaring exception
>>>> that now we get e.g. vdso64.so on x86_64 as the installed file instead
>>>> of vdso.so.  How much that actually matters, I have no idea.
>>>> Plausibly fixed with a symlink if we really need to perhaps.
>>>>
>>>
>>> You have that problem anyway, no?  After all, there are three different
>>> vdso images for 32 bits, and you can run 32-bit apps on 64-bit systems, too.
>>
>> Yeah, true.
>>
>>> Is there realistically any way for the debugger to pick up the correct one?
>>
>> Probably not.
>
> Sure there is: build ids.  See /usr/lib/debug/.build-id.

Oh, duh.

> It would be great if we could teach the various debugging tools
> (libdw?  gdb?  I don't know what's responsible for the search path) to
> search both /usr/lib/debug/.build-id and /lib/modules/`uname
> -r`/build-id or something like that.
>
>>
>> I'm planning on pushing out our first 3.16 build with
>> these two patches with no symlink.  I very much doubt anyone is going
>> to complain.  It was just something I noticed.
>
> Does the Fedora RPM magic debuginfo script notice these files and
> symlink them into the .build-id directory?
>
> Of course, we don't seem to be generating build ids right now.  I
> thought we were.  I'll see if I can fix it.

My builds have it:

[jwboyer@sb ~]$ file /lib/modules/3.16.0-0.rc0.git1.1.fc21.x86_64/vdso/vdso64.so
/lib/modules/3.16.0-0.rc0.git1.1.fc21.x86_64/vdso/vdso64.so: ELF
64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically
linked, BuildID[sha1]=0x85ab0014891b5be97871e5e1183b761b9d2e8d9d,
stripped
[jwboyer@sb ~]$

I forget if we're doing something special to get that or not.

josh
