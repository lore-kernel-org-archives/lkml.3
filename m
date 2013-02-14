Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934791Ab3BNRbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:31:47 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38157 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434Ab3BNRbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:31:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Goswin von Brederlow <goswin-v-b@web.de>,
        Li Fei <fei.li@intel.com>, len.brown@intel.com, mingo@redhat.com,
        peterz@infradead.org, biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH] fuse: make fuse daemon frozen along with kernel threads]
Date: Thu, 14 Feb 2013 18:38:02 +0100
Message-ID: <6332427.iqPUMjtDaQ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAJfpeguV5X1pwb-E7vzVtK4n0Q6Mu6A4XKnS5-tWn4Q7MtzgZg@mail.gmail.com>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <2891124.QXsiBPuYKW@vostro.rjw.lan> <CAJfpeguV5X1pwb-E7vzVtK4n0Q6Mu6A4XKnS5-tWn4Q7MtzgZg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 14, 2013 02:09:50 PM Miklos Szeredi wrote:
> On Thu, Feb 14, 2013 at 1:11 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, February 14, 2013 11:41:16 AM Miklos Szeredi wrote:
> 
> >>
> >> It is essentially the same mechanism that is used to delay the
> >> freezing of kernel threads after userspace tasks have been frozen.
> >> Except it's a lot more difficult to determine which userspace tasks
> >> need to be suspended late and which aren't.
> >
> > Well, I suppose that information is available to user space.
> >
> > Do we need an interface for a process to mark itself as PF_FREEZE_LATE or
> > do we need an interface for one process to mark another process as
> > PF_FREEZE_LATE, or both?
> 
> As a first step marking self with PF_FREEZE_LATE and inheriting this
> flag across fork/clone would work for most cases, I think.

OK, so we can just have a switch for that in /proc I suppose.

> Marking an unrelated process would have all sorts of issues: Who has
> permission to do this?  Won't it be misused to "fix" random freezer
> issues.

Yes, that's why I was asking.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
