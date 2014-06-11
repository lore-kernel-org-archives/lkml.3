Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaFKRnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:43:14 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:45170 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaFKRnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:43:11 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA7_B20q6mzq9yrbcQZEw0Z785pOCFeuTjKo7_9tn4_EsA@mail.gmail.com>
References: <5398749B.4090209@zytor.com> <cover.1402503408.git.luto@amacapital.net>
 <fe51e9f5c338d33b1a8b20813441538df5e17add.1402503408.git.luto@amacapital.net>
 <CA+5PVA5uPj0JiTLXJAtBt9b9e6aEcJh7ApFRbaCAP0=se89GKA@mail.gmail.com>
 <53989190.9010806@zytor.com> <CA+5PVA7_B20q6mzq9yrbcQZEw0Z785pOCFeuTjKo7_9tn4_EsA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 11 Jun 2014 10:42:50 -0700
Message-ID: <CALCETrXNLTL_VGo-epSdGY9ApXsmo_HLx90ncSsG1o18SmGTMg@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86,vdso: Fix vdso_install
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:33 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Wed, Jun 11, 2014 at 1:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/11/2014 10:23 AM, Josh Boyer wrote:
>>>
>>> So this does fix the invocation of 'make vdso_install' and the
>>> resulting files look to be accurate to me, with the glaring exception
>>> that now we get e.g. vdso64.so on x86_64 as the installed file instead
>>> of vdso.so.  How much that actually matters, I have no idea.
>>> Plausibly fixed with a symlink if we really need to perhaps.
>>>
>>
>> You have that problem anyway, no?  After all, there are three different
>> vdso images for 32 bits, and you can run 32-bit apps on 64-bit systems, too.
>
> Yeah, true.
>
>> Is there realistically any way for the debugger to pick up the correct one?
>
> Probably not.

Sure there is: build ids.  See /usr/lib/debug/.build-id.

It would be great if we could teach the various debugging tools
(libdw?  gdb?  I don't know what's responsible for the search path) to
search both /usr/lib/debug/.build-id and /lib/modules/`uname
-r`/build-id or something like that.

>
> I'm planning on pushing out our first 3.16 build with
> these two patches with no symlink.  I very much doubt anyone is going
> to complain.  It was just something I noticed.

Does the Fedora RPM magic debuginfo script notice these files and
symlink them into the .build-id directory?

Of course, we don't seem to be generating build ids right now.  I
thought we were.  I'll see if I can fix it.

--Andy

>
> josh



-- 
Andy Lutomirski
AMA Capital Management, LLC
