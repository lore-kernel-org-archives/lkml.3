Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3LLBhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:37:12 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59479 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751482Ab3LLBhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:37:05 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Kgene Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH V4] cpufreq: suspend governors on system suspend/hibernate
Date: Thu, 12 Dec 2013 02:50:13 +0100
Message-ID: <2173296.zTKqhC7Obn@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131208124108.GA4286@pd.tnic>
References: <28d493f20239a242a7b26dfe1efed40d83bf1e10.1385523340.git.viresh.kumar@linaro.org> <3466098.C5M665z3nb@vostro.rjw.lan> <20131208124108.GA4286@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 08, 2013 01:41:08 PM Borislav Petkov wrote:
> On Sun, Dec 08, 2013 at 01:34:36AM +0100, Rafael J. Wysocki wrote:
> > On Saturday, December 07, 2013 04:24:09 PM Paul Bolle wrote:
> > > On Sat, 2013-12-07 at 12:01 +0100, Bjørn Mork wrote:
> > > > Sorry to be making noise here again, but I was eager to verify that the
> > > > fixes in v3.13-rc3 were OK on my system.  Unfortunately it seems this
> > > > patch completely broke suspend for me.  Hibernete ended up with a blank
> > > > console and no visible activity, without ever writing any image to disk.
> > > > 
> > > > There really weren't that many suspects between v3.13-rc2 and v3.13-rc3,
> > > > so I went directly to reverting 5a87182aa21d ("cpufreq: suspend
> > > > governors on system suspend/hibernate") which fixed the problem. I
> > > > didn't bother debugging it further from there. I don't think there is
> > > > anything magic about my system which should make this problem specific
> > > > to it.
> > > > 
> > > > I am still using the acpi-cpufreq driver on an old x86_64 laptop if that
> > > > matters.
> > > 
> > > On an x86 (32 bits) laptop hibernate also broke in v3.13-rc3. On that
> > > machine hibernation itself worked, or at least seemed to work, but the
> > > machine would basically stop after thawing (directly after loading the
> > > hibernation image).
> > > 
> > > And reverting commit 5a87182aa21d ("cpufreq: suspend governors on system
> > > suspend/hibernate"), on top of v3.13-rc3, also lead to a successful
> > > hibernation/thaw cycle.
> > 
> > OK, reverted.
> 
> +1.
> 
> Grrr, I just wasted a whole morning bisecting the same issue as reported
> above and can confirm the revert is the right thing to do.
> 
> Well, almost: the box almost suspends until I hear the clicking sound of
> the mainboard trying to turn stuff off but then the fan remains on. When
> I hit a button on the keyboard, it then turns off completely. This is
> probably some nasty BIOS SMI crap which we don't have control over and
> I'd guess unrelated to the issue at hand.
> 
> Anyway, Rafael, I was wondering: I have a couple of boxes here and it
> would probably make a good sense to help out with testing this stuff
> more - I just can't have suspend breakages.
> 
> Maybe you'd like me to give a run of your tree now and then to check
> whether someone has sent you a quickly rushed brownpaper bag of
> questionable nature and we can fish it out before it hits Linus. :)
> 
> So let me know.

That would be great, thanks!

My tree is not too interesting at the moment from the cpufreq testing
perspective, but I'll let you know when there's more stuff in there.

Thanks,
Rafael

