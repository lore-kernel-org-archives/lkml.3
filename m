Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaFMR23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:28:29 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:35499 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbaFMR21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:28:27 -0400
MIME-Version: 1.0
In-Reply-To: <539B33E1.7040500@zytor.com>
References: <CA+5PVA5rP4cF14-ckD4K4MgBNtfHB+xPg3whEL26JkxegE7qpg@mail.gmail.com>
 <b10299edd8ba98d17e07dafcd895b8ecf4d99eff.1402586707.git.luto@amacapital.net>
 <CA+5PVA49T_hygP2O_ykqCpg6GFiJDds37LgroKvAfLSm0mkBKA@mail.gmail.com> <539B33E1.7040500@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 13 Jun 2014 10:28:06 -0700
Message-ID: <CALCETrV8vH=Mra_wuO_yNEi0WW+Cj2iudJFYghK9Uc0AS1PzMQ@mail.gmail.com>
Subject: Re: [PATCH v3] x86,vdso: Fix vdso_install
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 10:24 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/12/2014 10:01 AM, Josh Boyer wrote:
>> On Thu, Jun 12, 2014 at 11:28 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> The filenames are different now.  Inspired by a patch from
>>> Sam Ravnborg.
>>>
>>> Acked-by: Sam Ravnborg <sam@ravnborg.org>
>>> Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
>>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>>
>> Things look great with this version.  Thanks much!
>>
>> Tested-by: Josh Boyer <jwboyer@fedoraproject.org>
>>
>
> Are we okay with the 64-bit vdso now being installed as vdso64.so?

Unless someone actually complains, I think so.  Ideally, I think we'd
have a symlink from the build id, but that's a separate issue.

AFAIK, the only thing that actually references these files is Fedora's
gdb, which is finding them from Fedora's build-id symlinks, which
should work fine regardless of what the thing is called.

How's this for a patch description:

make vdso_install has been broken since this commit:

commit 6f121e548f83674ab4920a4e60afb58d4f61b829
Author: Andy Lutomirski <luto@amacapital.net>
Date:   Mon May 5 12:19:34 2014 -0700

    x86, vdso: Reimplement vdso.so preparation in build-time C

because the names of the files to be installed changed.   This fixes
vdso_install to install the right files.
