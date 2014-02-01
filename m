Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbaBAEV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 23:21:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56323 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbaBAEVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 23:21:55 -0500
Message-ID: <1391228495.5348.82.camel@marge.simpson.net>
Subject: Re: [PATCH RT 4/8] rtmutex: use a trylock for waiter lock in trylock
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Sat, 01 Feb 2014 05:21:35 +0100
In-Reply-To: <20140131220737.GF21238@linutronix.de>
References: <20140116015824.201732155@goodmis.org>
	 <20140116020324.637491369@goodmis.org>
	 <1389841737.5418.14.camel@marge.simpson.net>
	 <20140116232228.0f3cfb89@gandalf.local.home>
	 <1389935832.5449.23.camel@marge.simpson.net>
	 <20140131220737.GF21238@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:lbx0DHmqP/xrwp4BCmJ5Kq+4dnAaz5/4koBIInCNXBH
 P87XGfGJOmMz2VtsxnyHXuPGx2E2/sSbthB078CItMVjogVNDC
 Hr/xOevmk/fwFn/aG5oM158cLLuCgIHH2vV26gEYyeb4xtECyU
 99qA3tNOC8EB9Fel17R/WQQAYPS38E3QpmG6aN6YsLaKtTd5W/
 XxJ20Lb1NGRroRH5gF8nzpa6CYEnS3sncxQ3Mn3xuU5ZW6Zqit
 uFtm7IG6iTMDifdHYoBXxx4LsB3y1Kc0hybZ3W1WbyRyGp0t/0
 6Y/m+cVbaKj5yB7MOD2QajSuNNMSIz0qxSz2tvrf4Qcs8V9Oy9
 UZ9nsyL9zA7GyIiK+77nPKI7ivdIxt3NXPn2w4z3k/cdIAZTeY
 w6/papMhxtqnQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-31 at 23:07 +0100, Sebastian Andrzej Siewior wrote: 
> * Mike Galbraith | 2014-01-17 06:17:12 [+0100]:
> 
> >On Thu, 2014-01-16 at 23:22 -0500, Steven Rostedt wrote: 
> >> On Thu, 16 Jan 2014 04:08:57 +0100
> >> Mike Galbraith <bitbucket@online.de> wrote:
> >> 
> >> > On Wed, 2014-01-15 at 20:58 -0500, Steven Rostedt wrote:
> >> > 
> >> > 
> >> > > 3.2.53-rt76-rc1 stable review patch.
> >> > > If anyone has any objections, please let me know.
> >> > 
> >> > Not sure this is needed without the tglx don't unconditionally raise
> >> > timer softirq patch, and with that patch applied in the form it exists
> >> > in 3.12-rt9, as well as this one, you'll still eventually deadlock.
> >> 
> >> Hmm, I'll have to take a look. This sounds to be missing from all the
> >> stable -rt kernels. I'll be pulling in the latest updates from 3.12-rt
> >> soon.
> >
> >Below are the two deadlocks I encountered with 3.12-rt9, which has both
> >$subject and timers-do-not-raise-softirq-unconditionally.patch applied.
> 
> This patch was introduced because we had a deadlock in
> run_local_timers() which took a sleeping lock in hardirq context. This
> seem not to be the case in v3.2 therefore I would suggest not to take
> this patch here because it does not fix anything.
> 
> Mike, do you see these deadlocks with 3.12.*-rt11 as well?

No.  I beat 64 core box hard configured both nohz_idle and nohz_full,
the only thing that fell out was the nohz_full irqs enabled warning.

If Stevens patch didn't fix them, it did make them hide very well.

-Mike

