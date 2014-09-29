Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaI2VxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 17:53:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaI2VxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 17:53:01 -0400
Date: Mon, 29 Sep 2014 14:52:55 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] toshiba_acpi: Rename hci_raw to tci_raw
Message-ID: <20140929215254.GC34181@vmdeb7>
References: <1411518268-2773-1-git-send-email-coproscefalo@gmail.com>
 <1411518268-2773-2-git-send-email-coproscefalo@gmail.com>
 <20140926030126.GA40523@vmdeb7>
 <CAGdLNWEWu6wo_oD9WZMM1pgTV94uRWvteukNr5XmACVOgdO=1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdLNWEWu6wo_oD9WZMM1pgTV94uRWvteukNr5XmACVOgdO=1Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 10:35:04PM -0600, Azael Avalos wrote:
> 2014-09-25 21:01 GMT-06:00 Darren Hart <dvhart@infradead.org>:
> > On Tue, Sep 23, 2014 at 06:24:25PM -0600, Azael Avalos wrote:
> >> The function name hci_raw was used before to reflect
> >> a raw (read/write) call to the Toshiba's Hardware
> >> Configuration Interface (HCI), however, since the
> >> introduction of the System Configuration Interface
> >> (SCI), that "name" no longer applies.
> >>
> >> This patch changes the name of that function to
> >> tci_raw (for Toshiba Configuration Interface), and
> >> change the comments about it.
> >
> > I'm not following the motivation for this change. The HCI clearly still exists,
> > at least on the platforms this driver was written to support. When/Where was the
> > "SCI" "introduced" in a way that requires a change here? Was this a change by
> > Toshiba you are refering to?
> 
> The HCI and SCI form an integral part of the Toshiba configuration scheme,
> the SCI has been present on any Toshiba branded laptop to date, what
> was not present (at least on toshiba_acpi) was (propper) SCI support
> until the patches I sent.
> 
> Take a look at Jonathan Buzzard documentation [1], and also the toshiba
> module under char, the documentation was written in 1999, and the
> module has a (starting) date of 1996.
> 
> By the time toshiba_acpi was written, only HCI functions were accessed,
> as well as the configuration handle was (and still is, depending on model)
> named GHCI, and so the comments refer to it, now that we have SCI
> (driver support) on board, the naming seems obsolete, or at least
> misguiding, as the HCI is not the only configuration interface.
> 
> Hope this clears things a bit.
> 
> [1] http://www.buzzard.me.uk/toshiba/docs.html

What I'm getting from a quick scan of the documents is that both SCI and HCI are
enabled using the same read from B2, but SCI appears to be a superset of HCI (or
perhaps better said we are now using SCI+HCI and not just HCI.

This suggests to me that this driver has grown to include some SCI-specific
commands/features and now it's time to rename the interface to reflect this more
accurately.

Is that more or less the situation?

If this is more or less the lay of things, then please combine the function
definition change and callsite update patch (note that things should always
build at each patch to enable bisection, etc.), update the comments as you noted
below, and submit a V2.

It's a stretch for 3.18 as I'd prefer to have things in linux-next for two weeks
prior to submitting to Linus. Let's see how it goes.

Thanks,

> 
> >
> >
> >>
> >> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> >> ---
> >>  drivers/platform/x86/toshiba_acpi.c | 40 ++++++++++++++++++-------------------
> >>  1 file changed, 20 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> >> index edd8f3d..b7030dc 100644
> >> --- a/drivers/platform/x86/toshiba_acpi.c
> >> +++ b/drivers/platform/x86/toshiba_acpi.c
> >> @@ -71,7 +71,7 @@ MODULE_LICENSE("GPL");
> >>  /* Toshiba ACPI method paths */
> >>  #define METHOD_VIDEO_OUT     "\\_SB_.VALX.DSSX"
> >>
> >> -/* Toshiba HCI interface definitions
> >> +/* Toshiba configuration interface definitions
> >>   *
> >>   * HCI is Toshiba's "Hardware Control Interface" which is supposed to
> >
> > I'm not sure this patch is appropriate/necessary, but if so, you missed a spot
> > here :)
> 
> Oh no, this is intentional, what I probably should have done here is be more
> verbose about it, perhaps something like:
> 
> /*
>  * The Toshiba configuration interface is composed of the HCI and the
>  * SCI, which are defined as
> ...

-- 
Darren Hart
Intel Open Source Technology Center
