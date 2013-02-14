Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747Ab3BNMEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:04:35 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38090 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453Ab3BNMEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:04:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Goswin von Brederlow <goswin-v-b@web.de>,
        Li Fei <fei.li@intel.com>, len.brown@intel.com, mingo@redhat.com,
        peterz@infradead.org, biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH] fuse: make fuse daemon frozen along with kernel threads]
Date: Thu, 14 Feb 2013 13:11:01 +0100
Message-ID: <2891124.QXsiBPuYKW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAJfpegtUOCTNR-uzrFBcFY3K8to2+y3hvJx=vuBYS7emzU-SRA@mail.gmail.com>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <24327774.p6haZy6gvA@vostro.rjw.lan> <CAJfpegtUOCTNR-uzrFBcFY3K8to2+y3hvJx=vuBYS7emzU-SRA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 14, 2013 11:41:16 AM Miklos Szeredi wrote:
> On Wed, Feb 13, 2013 at 10:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, February 13, 2013 06:34:16 PM Miklos Szeredi wrote:
> 
> >>
> >> So I think the PF_FREEZE_DAEMON idea (the patch from Li Fei that
> >> started this thread) may still be our best bet at handling this
> >> situation.  The idea being that pure "originator" processes (ones that
> >> take no part in serving filesystem syscalls) can be frozen up-front.
> >> Then the "fuse daemon" (or "server") processes are hopefully in a
> >> quiescent state and can be frozen without difficulty.
> >>
> >> Unfortunately it needs help from userspace: the kernel can't easily
> >> guess which processes are part of a "fuse daemon" and which aren't.
> >> Fortunately we have a standard library (libfuse) that can tell it to
> >> the kernel for the vast majority of cases.
> >
> > So basically the idea would be to introduce something like PF_FREEZE_LATE
> > for user space processes that need to be frozen after all of the other
> > (non-PF_FREEZE_LATE) user space processes have been frozen and hack fuse
> > to use that flag?
> 
> Yes.
> 
> It is essentially the same mechanism that is used to delay the
> freezing of kernel threads after userspace tasks have been frozen.
> Except it's a lot more difficult to determine which userspace tasks
> need to be suspended late and which aren't.

Well, I suppose that information is available to user space.

Do we need an interface for a process to mark itself as PF_FREEZE_LATE or
do we need an interface for one process to mark another process as
PF_FREEZE_LATE, or both?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
