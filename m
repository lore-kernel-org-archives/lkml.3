Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab3DOCN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:13:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60269 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600Ab3DOCNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:13:55 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] watchdog: introduce new watchdog AUTOSTART option
Thread-Topic: [PATCH 1/2] watchdog: introduce new watchdog AUTOSTART option
Thread-Index: Ac43SjLoTe3v8WyVRY+JSd5SYCWIKAAA7mUAAIhtntD//5ZcAP//eafQ
Date: Mon, 15 Apr 2013 02:13:46 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E4BD49@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E4BBC2@DQHE02.ent.ti.com>
 <20130412151826.GC28704@roeck-us.net>
 <A874F61F95741C4A9BA573A70FE3998F82E4BD12@DQHE02.ent.ti.com>
 <20130415020642.GA29589@roeck-us.net>
In-Reply-To: <20130415020642.GA29589@roeck-us.net>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Guenter Roeck [mailto:linux@roeck-us.net]
> Sent: Monday, April 15, 2013 11:07 AM
> To: Kim, Milo
> Cc: wim@iguana.be; linux-watchdog@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] watchdog: introduce new watchdog AUTOSTART
> option
> 
> On Mon, Apr 15, 2013 at 12:43:31AM +0000, Kim, Milo wrote:
> > Hi Guenter
> >
> > > I really don't like that idea. It defeats a significant part of the
> > > purpose
> > > for having a watchdog, which is to prevent user-space hangups.
> > >
> > > To make this a driver option is even more odd - it forces every
> user of
> > > this
> > > driver to use it in-kernel only, and makes /dev/watchdog quite
> useless.
> > >
> > > I mean, really, if you have such a watchdog, what is the point of
> using
> > > the
> > > watchdog infrastructure in the first place ? Just make it a kernel
> > > thread or
> > > timer-activated platform code which pings your watchdog once in a
> while.
> > > No
> > > need to get the watchdog infrastructure involved in the first place.
> > >
> > > Am I missing something ?
> >
> > I wanted to enable the watchdog timer without the watchdog
> application for
> > making sure the system alive.
> > However, I think I misunderstood the purpose of the watchdog driver.
> > The watchdog is for detecting user-space hangups rather than kernel
> stall.
> > Is it correct? If yes, this patch is totally wrong.
> >
> Correct. After all, if the kernel stalls, user space will stall as well,
> so by
> covering user space it covers both. Covering kernel alone doesn't help
> much,
> since most of the stalls (at least in my experience) happen in user
> space.

Got it. I nearly spoiled it due to my misunderstanding ;)
Many thanks!

Milo
