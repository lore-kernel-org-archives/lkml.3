Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbaGSSV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 14:21:57 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36372 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaGSSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 14:21:55 -0400
From: Dmitry Torokhov <dtor@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Benson Leung <bleung@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrik Fimml <patrikf@chromium.org>,
        Bastien Nocera <hadess@hadess.net>, linux-pm@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Power-managing devices that are not of interest at some point in time
Date: Sat, 19 Jul 2014 11:21:52 -0700
Message-ID: <2047146.r4vphTZhkk@dtor-glaptop>
Organization: Google, Inc.
User-Agent: KMail/4.13.2 (Linux/3.13.0-32-generic; KDE/4.13.2; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1407191357140.28179-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1407191357140.28179-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 19, 2014 01:59:01 PM Alan Stern wrote:
> On Sat, 19 Jul 2014, Benson Leung wrote:
> > > This raises an interesting question.  Suppose the system gets suspended
> > > while the lid is closed.  At that point, shouldn't wakeup devices be
> > > enabled, even if they were already inhibited?
> > 
> > It's possible that this could be a policy decision, ie, whether
> > power/wakeup is set to enabled for those devices or not.
> > However, I'd say that there's only one policy that makes sense in that
> > case : wakeups should be disabled while suspended.
> > 
> > If we inhibited the device during runtime to prevent stray input
> > events from being generated, it wouldn't make sense to allow the
> > device to potentially generate an accidental wakeup while suspended.
> 
> That doesn't really make sense.  If you're afraid of a device
> generating spurious wakeup events when the lid is closed, you should
> never enable it for wakeup.  After all, one of the first things that
> people often do after suspending their laptop is close the lid.

That's a fair point, and I think should be done by default. But that does not 
change what Benson said - I think if we inhibited the device it should stay 
inhibited across system suspend, including being disabled as wakeup source 
even if it could be enabled as such.

Thanks,
Dmitry

