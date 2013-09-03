Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab3ICLiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 07:38:12 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:35049 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662Ab3ICLiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:38:10 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Sep 2013 07:38:10 EDT
Message-ID: <5225C7F0.10103@msgid.tls.msk.ru>
Date: Tue, 03 Sep 2013 15:28:48 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: linux-next@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] autofs4 - rename autofs4 to autofs
References: <20130831114133.11807.35953.stgit@perseus.themaw.net>
In-Reply-To: <20130831114133.11807.35953.stgit@perseus.themaw.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

31.08.2013 15:42, Ian Kent wrote:
[...]
> By leaving a Kconfig and Makefile in fs/autofs4 (to build autofs4.ko)
> with a deprication message sub-system maintainers and other users will
> make any needed changes before these are removed after two kernel versions.
> IMHO the presence of the warning is reason enough to leave a build stub
> rather than do a straight out rename.

Why do you want to continue building autofs4.ko? (or allowing to)
What's actually wrong with a stright rename?
If the new module can be auto-loaded by both name (by providing an
alias), there's no need to keep ability to build autofs4.ko, I think.

Well, maybe except of the case when autofs is needed in initramfs (like
for systemd).  For this, indeed, you can keep autofs4.ko which is a
dummy depending on autofs.ko...

> Ian Kent (10):
>       autofs4 - coding style fixes
>       autofs4 - fix string.h include in auto_dev-ioctl.h
>       autofs4 - move linux/auto_dev-ioctl.h to uapi/linux
>       autofs - merge auto_fs.h and auto_fs4.h
>       autofs - use autofs instead of autofs4 everywhere
>       autofs - copy autofs4 to autofs
>       autofs - create autofs Kconfig and Makefile
>       autofs - update fs/autofs4/Kconfig
>       autofs - update fs/autofs4/Makefile
>       autofs - delete fs/autofs4

By doing it this way, you're losing all git history.
If you perform stright rename and git detects it, you
can use, eg, git log --follow to see whole hostory
across rename.  This way you create new files without
history.

So I strongly shuggest actually renaming the subdirectory
(together with appropriate kconfig/makefile changes so
things are bisectable), and creating the stubs after this.

Thanks,

/mjt
