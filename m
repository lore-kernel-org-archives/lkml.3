Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaGSUBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 16:01:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54181 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752256AbaGSUBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 16:01:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dmitry Torokhov <dtor@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Benson Leung <bleung@chromium.org>,
        Patrik Fimml <patrikf@chromium.org>,
        Bastien Nocera <hadess@hadess.net>, linux-pm@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Power-managing devices that are not of interest at some point in time
Date: Sat, 19 Jul 2014 22:19:55 +0200
Message-ID: <3454348.ZgJ1ZIlfsF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2047146.r4vphTZhkk@dtor-glaptop>
References: <Pine.LNX.4.44L0.1407191357140.28179-100000@netrider.rowland.org> <2047146.r4vphTZhkk@dtor-glaptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 19, 2014 11:21:52 AM Dmitry Torokhov wrote:
> On Saturday, July 19, 2014 01:59:01 PM Alan Stern wrote:
> > On Sat, 19 Jul 2014, Benson Leung wrote:
> > > > This raises an interesting question.  Suppose the system gets suspended
> > > > while the lid is closed.  At that point, shouldn't wakeup devices be
> > > > enabled, even if they were already inhibited?
> > > 
> > > It's possible that this could be a policy decision, ie, whether
> > > power/wakeup is set to enabled for those devices or not.
> > > However, I'd say that there's only one policy that makes sense in that
> > > case : wakeups should be disabled while suspended.
> > > 
> > > If we inhibited the device during runtime to prevent stray input
> > > events from being generated, it wouldn't make sense to allow the
> > > device to potentially generate an accidental wakeup while suspended.
> > 
> > That doesn't really make sense.  If you're afraid of a device
> > generating spurious wakeup events when the lid is closed, you should
> > never enable it for wakeup.  After all, one of the first things that
> > people often do after suspending their laptop is close the lid.
> 
> That's a fair point, and I think should be done by default. But that does not 
> change what Benson said - I think if we inhibited the device it should stay 
> inhibited across system suspend, including being disabled as wakeup source 
> even if it could be enabled as such.

This seems to be the best approach to me too.

Rafael

