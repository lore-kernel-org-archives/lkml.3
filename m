Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaABLvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:51:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34382 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaABLvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:51:40 -0500
Date: Thu, 2 Jan 2014 12:51:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
Message-ID: <20140102115137.GA10982@amd.pavel.ucw.cz>
References: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
 <20131227150211.61328c02d61722cb212649e9@linux-foundation.org>
 <201312281243.CCB82366.tMHFVQFSOOFJOL@I-love.SAKURA.ne.jp>
 <CAMuHMdXVrL-9Fq3ixCZvh1TubGg7HFc0HKPbq-YYu+Q1zxWcEA@mail.gmail.com>
 <20131228112509.8a62548c.akpm@linux-foundation.org>
 <CAMuHMdWfi4mSQLA01_fYrs1ybQ5YysO2EF4q1EBNy+7nbKXN6g@mail.gmail.com>
 <1388260405.24123.18.camel@joe-AO722>
 <20131228120815.31f7d378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131228120815.31f7d378.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > #define PRINTK_PID      "\002"
> > > > #define PRINTK_TASK_ID  "\003"  /* "comm:pid" */
> > > >
> > > >         printk(PRINTK_TASK_ID ": hair on fire\n");
> > > >
> > > > It's certainly compact.  I doubt if there's any existing code which
> > > > deliberately prints control chars?
> > > 
> > > But the rest looks OK to me.
> > 
> > Tell me again, what's wrong with using p or current?
> > 
> > printk("%pt", current);
> 
> Nothing much.  It's just that all these callsites are generating the
> code to pass an argument which the callee already has access to. 
> Optimizing that will reduce text size a bit.

Can we do "printk("%pt", 0)", then? Or just pass current and live with
few bytes of penalty. There are probably less ugly ways to make kernel
smaller. Inventing another escape character for printk is extremely
ugly.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
