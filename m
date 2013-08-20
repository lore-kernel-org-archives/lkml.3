Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab3HTMia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:38:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab3HTMi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:38:29 -0400
Date: Tue, 20 Aug 2013 08:37:48 -0400
From: Dave Jones <davej@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Anton Arapov <anton@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ATTEND] oops.kernel.org prospect
Message-ID: <20130820123748.GB23101@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Anton Arapov <anton@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
	ksummit-2013-discuss@lists.linuxfoundation.org,
	linux-kernel@vger.kernel.org
References: <20130819085405.GA22328@bandura.laptop>
 <20130819145505.GB15178@kroah.com>
 <20130819151643.GC19070@bandura.laptop>
 <20130819153939.GA23875@thunk.org>
 <20130819155202.GF19070@bandura.laptop>
 <20130819212512.GA7918@redhat.com>
 <20130820080243.GB2613@bandura.laptop>
 <20130820082216.GA13078@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820082216.GA13078@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:22:16AM +0200, Borislav Petkov wrote:
 > On Tue, Aug 20, 2013 at 10:02:43AM +0200, Anton Arapov wrote:
 > > > * Visiting it with chromium gets an annoying warning about the https server
 > > > ...
 > > [snip]
 > > > ...
 > > > 	Dave
 > > 
 > > Thanks, Dave! Will be fixed and improved.
 > 
 > Yeah, collecting oopses is a good idea, so +1.
 > 
 > However, we probably want to think about what exactly we're going to
 > do with that information. For example, if I want to address an issue,
 > I probably want to know how I can reproduce the oops - maybe something
 > like allowing the reporter to add free text note to the oops.

abrt used to have a free-form entry like this.
What happened is users have no idea what to type in there, so you end up
with bugs containing things like "don't know" or worse, some crazy moon
language you can't even read.

 > And yes, as tytso already said, we are very often going to need more
 > info about a system causing the oops (dmesg, lspci, dmidecode, etc,
 > etc). I'm not sure how we're going to collect that without sacrificing
 > some privacy. Or maybe, we could be able to ask people to open a bug on
 > bugzilla.kernel.org where further debugging can take place...

Two things worth noting here, are 1) the original kerneloops also didn't
collect anything like this, and was still very useful, and 2) for the more
common issues (which let's face it, are going to be the only things
people really look at) chances are pretty high that there's going to be
someone also reporting it on lkml, or in a distro bug tracker.

What might be useful however, is collecting things like dmi/lspci/lsusb etc
and _asking_ the user if they're ok with including them at time of filing.
We might scare off some of the more paranoid OMGMYSECRETDATAS users, but
chances are high most people won't care.  This requires the client to have
a UI though, which aiui, it currently doesn't. Anton?

We might also ask if they want to provide an email address for feedback,
but that leads to a bunch of questions about how we expose that to developers
without exposing it to spambots.

	Dave

