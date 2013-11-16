Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3KPATl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:19:41 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54758 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752400Ab3KPATd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:19:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: shuah.kh@samsung.com
Cc: len.brown@intel.com, pavel@ucw.cz, gregkh@linuxfoundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, anton@enomsg.org, dwmw2@infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] power: Change device_wakeup_enable() to check for null dev_name(dev)
Date: Sat, 16 Nov 2013 01:32:05 +0100
Message-ID: <3366600.jMpqPVojcG@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5286B95F.4040306@samsung.com>
References: <1384560238-10708-1-git-send-email-shuah.kh@samsung.com> <4035469.UfR6Rto3I2@vostro.rjw.lan> <5286B95F.4040306@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 15, 2013 05:16:31 PM Shuah Khan wrote:
> On 11/15/2013 05:21 PM, Rafael J. Wysocki wrote:
> > On Friday, November 15, 2013 05:03:57 PM Shuah Khan wrote:
> >> device_wakeup_enable() uses dev_name(dev) as the wakeup source name.
> >> When it gets called with a device with its name not yet set, ws structure
> >> with ws->name = NULL gets created.
> >>
> >> When kernel is booted with wakeup_source_activate enabled, it will panic
> >> when the trace point code tries to derefernces ws->name.
> >>
> >> Change device_wakeup_enable() to check for dev_name(dev) null condition
> >> and return -EINVAL to avoid panics when device_wakeup_enable() gets called
> >> before device is fully initialized with its name.
>   		return -EINVAL;
> >
> > Can you please use WARN_ON(!dev_name(dev)) here?  While I agree that it is a
> > bad idea to crash the kernel because dev has no name, that indicates a driver
> > bug that shouldn't be too easy to ignore.
> >
> > Thanks!
> >
> 
> Right. ok I will re-cut the patch with WARN_ON and send it. fyi I did 
> send fix for the driver (power_supply) as well.
> 
> http://www.kernelhub.org/?msg=362354&p=2

That's OK (thanks for taking care of this), but there may be more brilliant
stuff like that in the future and people should see right away that something's
wrong in those cases.

Rafael

