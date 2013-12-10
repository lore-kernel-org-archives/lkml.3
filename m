Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3LJMxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:53:05 -0500
Received: from gloria.sntech.de ([95.129.55.99]:56007 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab3LJMxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:53:01 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.12 46/62] irq: Enable all irqs unconditionally in irq_resume
Date: Tue, 10 Dec 2013 13:52:53 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        ian.campbell@citrix.com, rjw@rjwysocki.net, len.brown@intel.com,
        Thomas Gleixner <tglx@linutronix.de>
References: <20131210080057.415644748@linuxfoundation.org> <20131210090113.GA22756@amd.pavel.ucw.cz> <20131210090847.GA4600@kroah.com>
In-Reply-To: <20131210090847.GA4600@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312101352.53714.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 10. Dezember 2013, 10:08:47 schrieb Greg Kroah-Hartman:
> On Tue, Dec 10, 2013 at 10:01:13AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > 3.12-stable review patch.  If anyone has any objections, please let
> > > 
> > >  me know.
> > 
> > Objections... well... I'm not sure if it meets stable criteria. In
> > particular, I don't think it was ever demonstrated as having bad
> > effect on the users.
> 
> Well, I'm guessing someone on the cc: here wanted it in stable@, so I'll
> let them speak up as to why...

As for bad effects on users ... any suspend_noirq callback returning an error 
and thus aborting the suspend will cause the error fixed by this, as the 
early-irqs won't get reenabled in the suspend-rollback [due to the syscore_ops 
doing their resume never being run].

You could for example lose keys connected thru the gpio-keys driver until the 
next reboot.

And it seems at least Laxman and myself were affected by it.


Heiko
