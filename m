Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab3EJSFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 14:05:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40677 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755988Ab3EJSFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 14:05:32 -0400
Date: Fri, 10 May 2013 14:05:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: BVG Rao <venubyravarasu@gmail.com>
cc: gregkh@linuxfoundation.org, <swarren@wwwdotorg.org>, <balbi@ti.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 04/10] Revert "usb: phy: tegra: don't call into
 tegra-ehci directly"
In-Reply-To: <CAH7OJZtx4-45vzGmzh6B3eW9GOmDEi7794FqZaenDgmcMUXYFg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1305101402220.1313-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013, BVG Rao wrote:

> On 10 May 2013 19:56, "Alan Stern" <stern@rowland.harvard.edu> wrote:
> >
> > On Fri, 10 May 2013, Venu Byravarasu wrote:
> >
> > > This reverts commit ee5d5499edb94cd03738a52a7e234b139da8fd72.
> > >
> > > Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> > > ---
> > > As PHY is being registered as separate driver, solution proposed with
> > > this patch cannot work anymore.
> > > Hence pushed patch 10 of this series to address the issue.
> >
> > You can't just revert a change like this -- doing so will recreate the
> > original problem that ee5d5499ed was meant to fix.
> >
> > You have to fix the problem _first_.  Then you can revert that commit.
> 
> Hi Alan,
> 
> I addressed that as part of patch 10 of the series.

I know -- that's what I was complaining about.  Patch 4 reverts the old
fix, and the new fix isn't added until patch 10.  So anybody who builds
a kernel using only patches 1 - 5 (for example) will end up with a
broken system.  This can easily happen during bisection testing.

You need to add the new fix either before or in the same patch as where 
the old fix is reverted.

Alan Stern

