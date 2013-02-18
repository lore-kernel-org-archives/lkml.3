Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3BRMTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 07:19:38 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39359 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3BRMTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 07:19:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Li, Fei" <fei.li@intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Pavel Machek <pavel@ucw.cz>,
        Goswin von Brederlow <goswin-v-b@web.de>,
        "Brown, Len" <len.brown@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Wang, Biao" <biao.wang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH] fuse: make fuse daemon frozen along with kernel threads]
Date: Mon, 18 Feb 2013 13:26:09 +0100
Message-ID: <3321530.AgvEeduuPx@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <BEC9F67575FA1E429CA7CF5AE9BE3634400F30@SHSMSX102.ccr.corp.intel.com>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <6332427.iqPUMjtDaQ@vostro.rjw.lan> <BEC9F67575FA1E429CA7CF5AE9BE3634400F30@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 18, 2013 06:26:34 AM Li, Fei wrote:
> 
> > -----Original Message-----
> > From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> > Sent: Friday, February 15, 2013 1:38 AM
> > To: Miklos Szeredi
> > Cc: Pavel Machek; Goswin von Brederlow; Li, Fei; Brown, Len;
> > mingo@redhat.com; peterz@infradead.org; Wang, Biao;
> > linux-pm@vger.kernel.org; fuse-devel@lists.sourceforge.net;
> > linux-kernel@vger.kernel.org; Liu, Chuansheng
> > Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH] fuse:
> > make fuse daemon frozen along with kernel threads]
> > 
> > On Thursday, February 14, 2013 02:09:50 PM Miklos Szeredi wrote:
> > > On Thu, Feb 14, 2013 at 1:11 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Thursday, February 14, 2013 11:41:16 AM Miklos Szeredi wrote:
> > >
> > > >>
> > > >> It is essentially the same mechanism that is used to delay the
> > > >> freezing of kernel threads after userspace tasks have been frozen.
> > > >> Except it's a lot more difficult to determine which userspace tasks
> > > >> need to be suspended late and which aren't.
> > > >
> > > > Well, I suppose that information is available to user space.
> > > >
> > > > Do we need an interface for a process to mark itself as PF_FREEZE_LATE or
> > > > do we need an interface for one process to mark another process as
> > > > PF_FREEZE_LATE, or both?
> > >
> > > As a first step marking self with PF_FREEZE_LATE and inheriting this
> > > flag across fork/clone would work for most cases, I think.
> > 
> > OK, so we can just have a switch for that in /proc I suppose.
> 
> Thanks for feedback and suggestion.
> 
> We have ever tried similar idea, expose interface /sys/power/pm_freeze_daemon,
> userspace tasks write 1 to this attribute to make itself to be frozen at the same time
> with kernel tasks, and it worked in our experiment.
> 
> Do you think it's suitable and enough to use such attribute /sys/power/pm_freeze_late, 
> or other more suitable place under /proc suggested?

I think it should be inder /proc, because that's where controls related to
process behavior are located.  E.g. /proc/PID/freeze_late or something like
that.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
