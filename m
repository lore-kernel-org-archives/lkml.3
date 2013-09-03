Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab3ICTY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:24:29 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34147 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3ICTYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:24:25 -0400
Date: Tue, 3 Sep 2013 12:24:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tom Gundersen <teg@jklm.no>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input: allow SERIO=m even without EXPERT=y
Message-ID: <20130903192421.GA26734@core.coreip.homeip.net>
References: <1378147630-12471-1-git-send-email-teg@jklm.no>
 <20130903150226.GA2392@srcf.ucam.org>
 <CAG-2HqVK+nH4+AFrBUmr6wp1zfTeUdLArmXxZxC4TwuPSSkKZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG-2HqVK+nH4+AFrBUmr6wp1zfTeUdLArmXxZxC4TwuPSSkKZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 06:25:28PM +0200, Tom Gundersen wrote:
> On Tue, Sep 3, 2013 at 5:02 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Mon, Sep 02, 2013 at 08:47:10PM +0200, Tom Gundersen wrote:
> >> There is plenty of consumer hardware (e.g., mac books) that does not use
> >> AT keyboards or PS/2 mice. It therefore makes sense for distro kernels
> >> to build the related drivers as modules to avoid loading them on hardware
> >> that does not need them. As such, these options should no longer be protected
> >> by EXPERT.
> >
> > There are systems (although, with luck, only *very* old ones) where the
> > modules won't get autoloaded. You should probably mention that in the
> > help text.
> 
> Good point, if this turns out to be a problem on current hardware
> distros probably want to load the modules automatically at boot by
> default.

Presumably such systems would carry over their .config which would have
these as built-in.

> 
> Does this problem only apply to the i8042 module or also atkbd and libps2?

Atkbd should be able to load automatically (as long as modutils support
SERIO bus, which any recentish - 5 years? - modutils should do).

libps2 should load automatically to resolve dependencies of
atkbd/psmouse.

i8042 is old-style platform driver, so nothing will load it if it is
compiled as a module. This one worries me most.

mousedev should load automatically if something tries to open it's
device nodes.

Thanks.

-- 
Dmitry
