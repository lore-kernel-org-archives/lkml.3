Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbaBDQRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:17:30 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:39292 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaBDQR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:17:27 -0500
MIME-Version: 1.0
In-Reply-To: <1391513615.2766.18.camel@menhir>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
	<1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
	<CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
	<20140130075421.GA10050@infradead.org>
	<CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
	<20140203102943.GF11829@infradead.org>
	<CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
	<20140203215908.GD10323@ZenIV.linux.org.uk>
	<CA+55aFz3PyyCqOLs_SBRS3cbGxWd5ez4Svz2+xK+4KtCez8iGw@mail.gmail.com>
	<20140203224034.GF10323@ZenIV.linux.org.uk>
	<1391513615.2766.18.camel@menhir>
Date: Tue, 4 Feb 2014 08:17:26 -0800
X-Google-Sender-Auth: F3LIxvhRZbalihP3Fwe4179g_zk
Message-ID: <CA+55aFz2FLCcNpLz_ey4YaKsLov+Mpjdt4onXVmw5n3z7o_TRg@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 3:33 AM, Steven Whitehouse <swhiteho@redhat.com> wrote:
>
> The other question that I have relating to that side of things, is why
> security_inode_permission() is called from __inode_permission() rather
> than from generic_permission() ? Maybe there is a good reason, but I
> can't immediately see what it is at the moment.

"generic_permission()" is just a helper that implements the default
UNIX permissions, and won't necessarily even be called. A filesystem
could decide not to call it at all, and in fact there are cases that
don't (eg coda or the bad_inode case).

The inode_permission() class of helpers, in contrast, is what gets
called by the VFS layer itself. So if you want to catch all permission
checks (and that would be security_inode_permission()) then you need
to catch it there.

                     Linus
