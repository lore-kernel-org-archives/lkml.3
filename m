Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab3ICMrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:47:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55687 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab3ICMrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:47:20 -0400
X-Sasl-enc: /RH9cvIg++fCip+xv0nOvWe4fpQxb/GDiQ2olkA82HoF 1378212436
Message-ID: <1378212433.2310.3.camel@perseus.fritz.box>
Subject: Re: [PATCH 00/10] autofs4 - rename autofs4 to autofs
From: Ian Kent <raven@themaw.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-next@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 03 Sep 2013 20:47:13 +0800
In-Reply-To: <5225C7F0.10103@msgid.tls.msk.ru>
References: <20130831114133.11807.35953.stgit@perseus.themaw.net>
	 <5225C7F0.10103@msgid.tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-03 at 15:28 +0400, Michael Tokarev wrote:
> 31.08.2013 15:42, Ian Kent wrote:
> [...]
> > By leaving a Kconfig and Makefile in fs/autofs4 (to build autofs4.ko)
> > with a deprication message sub-system maintainers and other users will
> > make any needed changes before these are removed after two kernel versions.
> > IMHO the presence of the warning is reason enough to leave a build stub
> > rather than do a straight out rename.
> 
> Why do you want to continue building autofs4.ko? (or allowing to)
> What's actually wrong with a stright rename?
> If the new module can be auto-loaded by both name (by providing an
> alias), there's no need to keep ability to build autofs4.ko, I think.

The hope is that within two subsequent kernel versions, when it is
removed, people that need to change will have noticed this and made the
needed changes. That's scripts that may have looked for autofs4.ko to
work around the auto-load problem, aliases that won't work now, kernel
configurations, etc...

The configuration message for autofs4 now says these things and says the
module is going to be removed.

> 
> Well, maybe except of the case when autofs is needed in initramfs (like
> for systemd).  For this, indeed, you can keep autofs4.ko which is a
> dummy depending on autofs.ko...
> 
> > Ian Kent (10):
> >       autofs4 - coding style fixes
> >       autofs4 - fix string.h include in auto_dev-ioctl.h
> >       autofs4 - move linux/auto_dev-ioctl.h to uapi/linux
> >       autofs - merge auto_fs.h and auto_fs4.h
> >       autofs - use autofs instead of autofs4 everywhere
> >       autofs - copy autofs4 to autofs
> >       autofs - create autofs Kconfig and Makefile
> >       autofs - update fs/autofs4/Kconfig
> >       autofs - update fs/autofs4/Makefile
> >       autofs - delete fs/autofs4
> 
> By doing it this way, you're losing all git history.
> If you perform stright rename and git detects it, you
> can use, eg, git log --follow to see whole hostory
> across rename.  This way you create new files without
> history.
> 
> So I strongly shuggest actually renaming the subdirectory
> (together with appropriate kconfig/makefile changes so
> things are bisectable), and creating the stubs after this.
> 
> Thanks,
> 
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe autofs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


