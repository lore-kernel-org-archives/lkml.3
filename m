Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935427Ab3DPBfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 21:35:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:47444 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935188Ab3DPBfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 21:35:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,480,1363158000"; 
   d="scan'208";a="322817407"
Message-ID: <1366076105.2323.0.camel@rzhang1-mobl4>
Subject: Re: still in 3.9-rc6 - fan speed at 100% after suspend/resume
 regression
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
        Jake Edge <jake@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roberto Oppedisano <roberto.oppedisano@gmail.com>,
        Salvatore Sisinni <s.sisinni@gmail.com>, auxsvr@gmail.com
Date: Tue, 16 Apr 2013 09:35:05 +0800
In-Reply-To: <516C00EC.8060300@ti.com>
References: <20130413100221.70c040fa@chukar.edge2.net>
	 <20130413214359.GG25821@sci.fi> <20130413234646.GH25821@sci.fi>
	 <516C00EC.8060300@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 09:30 -0400, Eduardo Valentin wrote:
> On 13-04-2013 19:46, Ville Syrjälä wrote:
> > On Sun, Apr 14, 2013 at 12:44:00AM +0300, Ville Syrjälä wrote:
> >> On Sat, Apr 13, 2013 at 10:02:21AM -0600, Jake Edge wrote:
> >>> Hi Zhang Rui,
> >>>
> >>> The problem reported in https://lkml.org/lkml/2012/12/4/428 (and
> >>> incorrectly attributed to a suspend patch by me here:
> >>> https://lkml.org/lkml/2013/4/12/314) still exists in 3.9-rc6, at least
> >>> for my HP/Compaq 2510p laptop. It appeared that some folks were seeing
> >>> some improvement with earlier 3.9-rcs (?) but I just tested rc6 and saw
> >>> substantially the same behavior.  This all works fine in <= 3.6.11.
> >>>
> >>> A brief recap: after resuming, the fan on the laptop spins up to full
> >>> speed and stays there. "temp6" in "acpitz-virtual-0" (as shown by
> >>> "sensors") is 100°C and stays there, which is presumably what is making
> >>> the fan stay on.
> >>
> >> My HP Compaq NC6000 exhibits slightly different behaviour. For me the
> >> reported temp is always accurate but the trip points get out of sync
> >> with the actual temperature.
> >>
> >> With 3.7 I saw two different kinds of problems coming out of resume.
> >> In one case the fan stays on until the temp rises high enough to get the
> >> trip points back into sync. In the other case the fan goes off, and stays
> >> off even when the temperature rises above the highest active trip point,
> >> but it does appear to get back into sync when the temp starts to come back
> >> down. I think the difference might stem from resuming when the laptop has
> >> cooled down fully vs. when it's still warm.
> >>
> >> I also just tried 3.9-rc6, and that one appears to behave differently
> >> to 3.7, but still wrong. There the fan goes off after resume, and comes
> >> back on as the temperature rises, but it never slows back down after
> >> that.
> >>
> >> I'll try to collect some more detailed dumps of all three cases.
> >
> > I filed a new bug and attached all my logs:
> > https://bugzilla.kernel.org/show_bug.cgi?id=56591
> >
> 
> 
> Rui, does this one gets fixed with your series to make the parts of 
> thermal framework to be glued together in a single module?

No.

>  Or does this 
> one is a new bug?
> 
right, it is a new bug.

thanks,
rui


