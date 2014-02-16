Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaBPX0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:26:14 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59875 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752381AbaBPX0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:26:11 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: Re: [PATCH 0/5] Enabling the asynchronous threads for other phases
Date: Mon, 17 Feb 2014 00:40:59 +0100
Message-ID: <9364493.5ysfSuJl7g@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01C1AF9E@SHSMSX101.ccr.corp.intel.com>
References: <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com> <2360514.bLFmJYMItS@vostro.rjw.lan> <27240C0AC20F114CBF8149A2696CBE4A01C1AF9E@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 10, 2014 08:36:57 AM Liu, Chuansheng wrote:
> Hello Rafael,
> 
> > -----Original Message-----
> > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > Sent: Thursday, February 06, 2014 5:53 AM
> > To: Liu, Chuansheng
> > Cc: gregkh@linuxfoundation.org; pavel@ucw.cz; Brown, Len;
> > linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Zhuangzhi
> > Subject: Re: [PATCH 0/5] Enabling the asynchronous threads for other phases
> > 
> > On Monday, January 20, 2014 04:44:34 PM Liu, Chuansheng wrote:
> > > Hello,
> > >
> > > This patch series are for enabling the asynchronous threads for the phases
> > > resume_noirq, resume_early, suspend_noirq and suspend_late.
> > >
> > > Just like commit 5af84b82701a and 97df8c12995, with async threads it will
> > > reduce the system suspending and resuming time significantly.
> > >
> > > With these patches, in my test platform, it saved 80% time in resume_noirq
> > > phase.
> > >
> > > Has done the suspend-resume stress test for a long time, please help to
> > > review.
> > >
> > > Best Regards,
> > >
> > > [PATCH 1/5] PM: Adding two flags for async suspend_noirq and
> > > [PATCH 2/5] PM: Enabling the asynchronous threads for resume_noirq
> > > [PATCH 3/5] PM: Enabling the asyncronous threads for resume_early
> > > [PATCH 4/5] PM: Enabling the asyncronous threads for suspend_noirq
> > > [PATCH 5/5] PM: Enabling the asyncronous threads for suspend_late
> > 
> > I've applied this to the bleeding-edge branch of the linux-pm.git tree, with
> > minor changes related to coding style, white space etc.
> Thanks your help.

Unfortunately, I've just realized that your patches don't add any mechanism
ensuring that parent devices' .suspend_noirq() will be called *after* the
.suspend_noirq() of all their children.  Of course, analogously for
.suspend_late() and for the resume part (where children have to wait for
their parents).

In the original async suspend/resume code that is implemented using
power.completion and I suppose you can do the same thing here.

I have to drop the series for the time being.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
