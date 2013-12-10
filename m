Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab3LJWZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:25:34 -0500
Received: from gloria.sntech.de ([95.129.55.99]:34101 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab3LJWZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:25:31 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.12 46/62] irq: Enable all irqs unconditionally in irq_resume
Date: Tue, 10 Dec 2013 22:46:54 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        ian.campbell@citrix.com, rjw@rjwysocki.net, len.brown@intel.com,
        Thomas Gleixner <tglx@linutronix.de>
References: <20131210080057.415644748@linuxfoundation.org> <201312101352.53714.heiko@sntech.de> <20131210192702.GC8075@kroah.com>
In-Reply-To: <20131210192702.GC8075@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201312102246.54581.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 10. Dezember 2013, 20:27:02 schrieb Greg Kroah-Hartman:
> On Tue, Dec 10, 2013 at 01:52:53PM +0100, Heiko Stübner wrote:
> > Am Dienstag, 10. Dezember 2013, 10:08:47 schrieb Greg Kroah-Hartman:
> > > On Tue, Dec 10, 2013 at 10:01:13AM +0100, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > 3.12-stable review patch.  If anyone has any objections, please let
> > > > > 
> > > > >  me know.
> > > > 
> > > > Objections... well... I'm not sure if it meets stable criteria. In
> > > > particular, I don't think it was ever demonstrated as having bad
> > > > effect on the users.
> > > 
> > > Well, I'm guessing someone on the cc: here wanted it in stable@, so
> > > I'll let them speak up as to why...
> > 
> > As for bad effects on users ... any suspend_noirq callback returning an
> > error and thus aborting the suspend will cause the error fixed by this,
> > as the early-irqs won't get reenabled in the suspend-rollback [due to
> > the syscore_ops doing their resume never being run].
> > 
> > You could for example lose keys connected thru the gpio-keys driver until
> > the next reboot.
> > 
> > And it seems at least Laxman and myself were affected by it.
> 
> So, to be clear, this patch fixes a problem on your machines, right?

yes it does fix a problem I ran into on my machines.


Heiko
