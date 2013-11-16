Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab3KPLBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 06:01:16 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36684 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3KPLBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 06:01:06 -0500
MIME-Version: 1.0
In-Reply-To: <20131116084505.GA26233@chokladfabriken.org>
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
	<5285EE5A.1070202@southpole.se>
	<20131116084505.GA26233@chokladfabriken.org>
Date: Sat, 16 Nov 2013 12:01:04 +0100
Message-ID: <CAKaYPCNOLbX09Pqx7Zn=ivO++iBZMbBpu-pMjNgayVDBrBX1yQ@mail.gmail.com>
Subject: Re: [ORLinux] [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
From: Olof Kindgren <olof.kindgren@gmail.com>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Jonas Bonn <jonas@southpole.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Mehall <contact@kevinmehall.net>, linux <linux@openrisc.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/16 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
>
> On Fri, Nov 15, 2013 at 10:50:18AM +0100, Jonas Bonn wrote:
> > >+
> > >+    i2c0: ocores@a0000000 {
> > >+            #address-cells = <1>;
> > >+            #size-cells = <0>;
> > >+            compatible = "opencores,i2c-ocores";
> >
> > Version number needed.  OpenCores wanted "projectname-rtlsvn###"
> > where ### is the SVN commit number of the RTL directory in the
> > project's source repository.
> >
>
> That will also require a change to the driver.
>
> Using svn commit ids as version info seems a bit too fine grained to me,
> but if that's what's agreed on, then it should be the commit id from the
> projects official repository at opencores.org I think.
>
> Stefan
> _______________________________________________
> Linux mailing list
> Linux@lists.openrisc.net
> http://lists.openrisc.net/listinfo/linux


I agree. I don't like doing versioning with revision numbers. It's too
closely tied to the currently used VCS. The problem is that no one has
bothered to do proper releases of the cores for the last ten years or
so.

But since we are talking about a relatively small amount of cores
here, I think it could be worth to take a quick glance to see if the
latest SVN version is compatible with the latest tagged release. I
would suspect that is the case for the majority of the cores and the
we can just use the latest tag as version. For the other cores we
could
1. Use latest tag + 1 (a bit ugly if the maintainer wants to do a proper release
2. Take over maintainership/fork and just release what's in the trunk
(taking over maintenance is preferrable here to avoid  more repo
confusion)
3. Use SVN revisions

option 2 would be my preferred choice here, given that we get someone
to do the actual work. I could probably help out with a few of the
cores

Jonas, you said that opencores wanted projectname-svnversion. Do you
know where that comes from? My proposal here would conflict with that

//Olof
