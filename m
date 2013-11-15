Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3KOXL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:11:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64042 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751047Ab3KOXLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:11:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: rafael.j.wysocki@intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v3.11][3.12][Regression]  ACPI / processor: Use common hotplug infrastructure
Date: Sat, 16 Nov 2013 00:23:54 +0100
Message-ID: <1770440.aHQcEYdRzT@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5014016.kNGQWXsIS0@vostro.rjw.lan>
References: <52865D6B.1080902@canonical.com> <7794021.qcx8jVI5m1@vostro.rjw.lan> <5014016.kNGQWXsIS0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 16, 2013 12:16:05 AM Rafael J. Wysocki wrote:
> On Saturday, November 16, 2013 12:00:50 AM Rafael J. Wysocki wrote:
> > On Friday, November 15, 2013 11:55:10 PM Rafael J. Wysocki wrote:
> > > On Friday, November 15, 2013 12:44:11 PM Joseph Salisbury wrote:
> > > > Hi Rafael,
> > > > 
> > > > A kernel bug affecting several users was opened against Ubuntu[0]. 
> > > > After a bisect, it was found the following commit introduced the regression:
> > > > 
> > > > commit ac212b6980d8d5eda705864fc5a8ecddc6d6eacc
> > > > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > Date: Fri May 3 00:26:22 2013 +0200
> > > > 
> > > >     ACPI / processor: Use common hotplug infrastructure
> > > > 
> > > > The regression was introduced as of v3.11-rc1.
> > > > 
> > > > This commit doesn't revert cleanly in 3.12, and requires the revert of
> > > > other commits as well.  I wanted to get your feedback since you are the
> > > > author.
> > > 
> > > Well, that commit has nothing to do with PCMCIA, so I'm not sure how the
> > > breakage is related to it.
> > > 
> > > Moreover, comment #8 reports 3.11.0-11.17 as working and the change you're
> > > asking about should be in that kernel as well.
> > 
> > Ah, so that was bogus.
> > 
> > Well, I'm still not sure how the commit in question may affect PCMCIA.  I have
> > a test machine with PCMCIA and it boots correctly with 3.11+.
> 
> The bisect could just trip over a different bug in that commit that was fixed
> later.
> 
> Moreover, comment #70 indicates that 3.11.0-11-generic works correctly for
> someone.
> 
> I'm also unsure what comment #43 means.
> 
> And I wonder if the reported who "bisected" this can boot without PCMCIA?

One more thing.  Comment #32 says that the reporter could not reproduce the
problem without "the -extras package which contains the PCMCIA drivers."  So
I'm wondering why exactly the PCMCIA drivers are in that package?

Rafael

