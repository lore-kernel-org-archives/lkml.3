Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3BJXYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 18:24:42 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36915 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335Ab3BJXYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 18:24:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Goswin von Brederlow <goswin-v-b@web.de>, Li Fei <fei.li@intel.com>,
        len.brown@intel.com, mingo@redhat.com, peterz@infradead.org,
        biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH] fuse: make fuse daemon frozen along with kernel threads]
Date: Mon, 11 Feb 2013 00:31:03 +0100
Message-ID: <2964781.rPUOipNRNb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130210185504.GA17268@amd.pavel.ucw.cz>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <3938124.8eafYb16IB@vostro.rjw.lan> <20130210185504.GA17268@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 10, 2013 07:55:05 PM Pavel Machek wrote:
> Hi!
> 
> > > > > The whole memory shrinking we do for hibernation is now done by allocating
> > > > > memory, so the freezer is not necessary for *that* and there's *zero*
> > > > > difference between suspend and hibernation with respect to why the freezer is
> > > > > used.
> > > > 
> > > > Funny. Freezer was put there so that hibernation image was safe to
> > > > write out. You need disk subsystems in workable state for hibernation.
> > > 
> > > I'm not really sure what you're talking about.  Why do you think the freezer is
> > > necessary for that?
> 
> Well, from freezer you need:
> 
> 1) user process frozen.
> 
> 2) essential locks _not_ held so that block devices are still functional.
> 
> > > > mmap... what is problem with mmap? For suspend, memory is powered, so
> > > > you can permit people changing it.
> > > 
> > > Suppose mmap is used to make the registers of some device available to user
> > > space.  Yes, that can happen.
> 
> "Don't do it, then". Yes, can happen, but hopefully is not too common
> these days. [And... freezer doing 1) but not 2) would be enough to
> handle that. Freezer doing 1) but not 2) would also be simpler...]

Again, I'm not sure what you mean.

Are you trying to say that it would be OK to freeze user space tasks in
the D state?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
