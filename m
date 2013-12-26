Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3LZXJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 18:09:41 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60366 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753860Ab3LZXJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 18:09:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        Linux-pm mailing list <linux-pm@vger.kernel.org>
Subject: Re: No freezing of kernel threads (was: Re: [GIT PULL] libata fixes for v3.13-rc5)
Date: Fri, 27 Dec 2013 00:23:10 +0100
Message-ID: <2054754.LytUAbbREV@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131226190120.GC16483@htj.dyndns.org>
References: <20131226160517.GB16483@htj.dyndns.org> <Pine.LNX.4.44L0.1312261326540.24521-100000@netrider.rowland.org> <20131226190120.GC16483@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 26, 2013 02:01:20 PM Tejun Heo wrote:
> Hey,
> 
> On Thu, Dec 26, 2013 at 01:42:29PM -0500, Alan Stern wrote:
> > In the case of hibernation, it's not so simple.  We do need to perform 
> > I/O, in order to save the memory image.  But we also need to avoid 
> > unnecessary I/O, in order to keep the on-disk data consistent with the 
> > data in the memory image.  You probably can't accomplish this at the 
> > device driver or subsystem level.
> 
> That was what I assumed too but Rafael tells me it has nothing to do
> with hibernation.

It doesn't prevent on-disk data corruption from happening in case of a failing
hibernation.  In case of a successful hibernation it is key to keep on-disk
data in sync with the contents of the image, but relying on the freezing
for that is rather not a winning strategy, so to speak.  It would be better
to freeze filesystems instead (which has been discussed in another thread
recently).

Thanks,
Rafael

