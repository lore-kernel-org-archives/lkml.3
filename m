Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaFXXVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:21:02 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62124 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751805AbaFXXU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:20:59 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
Date: Wed, 25 Jun 2014 01:38:43 +0200
Message-ID: <3098868.U0NfB8kYvJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1406221239060.17183-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1406221239060.17183-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 22, 2014 12:45:42 PM Alan Stern wrote:
> On Sun, 22 Jun 2014, Rafael J. Wysocki wrote:
> 
> > > How would you treat them specially?  Add a "runtime_pm_not_supported" 
> > > flag?
> > 
> > I thought about a "runtime PM has been enabled at least once" flag rather
> > that would be set by pm_runtime_enable() every time it is called and never
> > cleared.  That would allow the core to distinguish between "runtime PM
> > disabled temporarily" and "runtime PM not used" which turn out to be
> > sufficiently different cases.
> 
> Interesting idea, but it can't tell the difference between "runtime PM
> not supported" and "runtime PM not enabled yet".  I think a simple "not
> supported" flag will be more straightforward.

The question is who will set the "unsupported" flag (think devices without
drivers etc.).  Or perhaps the idea is that it will be set to start with?

> > Yes.  The core definitely needs to be able to distinguish between the
> > "runtime PM disabled temporarily" and "runtime PM not supported/not used"
> > situations.
> 
> Let me work out a patch, and we'll see what you think.  For the time
> being we can stick with our "runtime PM must be disabled (or in error)  
> when the status is changed" approach.

OK

Rafael

