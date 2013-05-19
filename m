Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3ESN2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 09:28:50 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:54678 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3ESN2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 09:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAPweEDzsCf3rQB_hZ2=OH_b8McYRY7VUit=j-1=aVSd7vbM+og@mail.gmail.com>
References: <CAPweEDxgT+ZygfPZDd8YePe7RurTU7o_UtiBqjUvCMimChpTug@mail.gmail.com>
 <1368918189923.dd7325ed@Nodemailer> <CAPweEDwYm6iQ1vJ_UwAC5pE-uwfnMDHR6wJ1VppW1wakmTMJGQ@mail.gmail.com>
 <CAOiHx=ksyGWYZhafde_5NqUf1wpyWKNc3rs5heFHsNKD8GhXGQ@mail.gmail.com> <CAPweEDzsCf3rQB_hZ2=OH_b8McYRY7VUit=j-1=aVSd7vbM+og@mail.gmail.com>
From: Jonas Gorski <jonas.gorski+gpl@gmail.com>
Date: Sun, 19 May 2013 15:28:28 +0200
X-Google-Sender-Auth: 9t0DsR07pf0M_rYgbbcbTwW9N_k
Message-ID: <CAOiHx=nh5dBSEHL06mH-e4YGn7TCSaaBuOQU=JBJcnxQUWLBDw@mail.gmail.com>
Subject: Re: Would like to form a pool of Linux copyright holders for faster
 GPL enforcement against Anthrax Kernels
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: Cole Johnson <coleharrisjohnson@gmail.com>, legal@lists.gpl-violations.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 2:34 PM, luke.leighton <luke.leighton@gmail.com> wrote:
> On Sun, May 19, 2013 at 12:19 PM, Jonas Gorski
> <jonas.gorski+gpl@gmail.com> wrote:
>
>> But dual license means the license taker may chose which license to
>> apply, not that you can dictate which one to use.
>
>  yes.
>
>> And as long as any
>> part of the kernel is GPLv2 (no +), (s)he can't choose anything except
>> GPLv2, as GPLv2 and GPLv3 are incompatible.
>
>  that doesn't sound right.  actually, this is a very very important
> misunderstanding, jonas.
>
>  you *can* choose GPLv3 code.  what you can choose is: *only* those
> files of the linux kernel that are released under GPLv3.
>
>
>  pseudo-algorithm in bash script and maybe a bit of python:
>
>  $ filenames_gplv3 = `find . | xargs grep -l GPLv3`
>  $ filenames_gplv2 = `find . | xargs grep -l GPLv2`
>  $ files_to_delete = []
>  $ for x in filenames_gplv2:
>     if x not in filenames_gplv2:
>         files_to_delete.append(x)
>  $ for x in files_to_delete:
>      rm $x
>
> after that procedure is done, _then_ try doing a kernel compile, see
> how far you get.

This will produce an empty directory.

There are 0 files released under GPLv3 (because its incompatible with
GPLv2). There are some release under GPLv2+, but this is mostly
drivers and architecture specific code, and a collection of drivers
does not make a kernel.

Almost nothing of the parts that define a kernel (like memory and
process management) are GPLv2+. Therefore I say the kernel will always
be GPLv2, no matter how many files you *add* that are GPLv2+.

> many people point out that just because this is unlikely to result in
> success any time in the next 100 years, that nobody should bother even
> starting.

Because Linus /is/ the highest authority regarding Linux. He holds the
copyright to the most crucial parts, and without his cooperation, you
will never get the GPLv2 parts to be re-licensed to GPLv2+, unless you
remove everything from him and replace it with your own
implementations. And do the same with every other contributors' code
who doesn't agree to switch to GPLv2+.

>> So any further licenses will never apply to any use in the kernel.
>
>  incorrect!!  logical assertion error!! :)  assert(ELOGICALCONCLUSIONBRAINFART)
>
>> Only if somebody took your code out of the kernel and used it in a
>> separate GPLv3+ project, then the GPLv3+ license could and would
>> apply.
>
>  after reviewing the above pseudo-code i believe you'll agree that
> that's slightly misleading. one could also choose to leave the files
> in-place in the *same* project's source tree, and just not use any of
> the ones that were incompatibly-licensed.

Have fun with that. That isn't a kernel any more, that's a loose
collection of drivers and architecture support code.

You will have to re-invent every GPLv2 only part they link
against/require, or rewrite the GPLv2+ code to not use it. And if you
finally got it to work, it has already become a separate project as it
won't have much resemblance with the Linux kernel any more. ;-)

Also no company will ever bother to do that, because choosing GPLv3
will only bring disadvantages to them. And writing their own kernel/OS
will likely be less work and more rewarding, because then they own the
copyright for it and can choose any license they want.


Jonas
