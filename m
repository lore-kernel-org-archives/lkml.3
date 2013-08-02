Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3HBBLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:11:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3HBBLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:11:37 -0400
Date: Fri, 2 Aug 2013 03:11:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        joseph.salisbury@canonical.com,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] HID: hid-logitech-dj, querying_devices was never
 set
In-Reply-To: <CAN+gG=GcS7pfK9K5FuW9TyX+PJWNkXZWLk8UX9PzLXom2PSpgQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1308020309340.24017@pobox.suse.cz>
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com> <1374153691-25100-2-git-send-email-nlopezcasad@logitech.com> <CAN+gG=GcS7pfK9K5FuW9TyX+PJWNkXZWLk8UX9PzLXom2PSpgQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Aug 2013, Benjamin Tissoires wrote:

> > Set querying_devices flag to true when we start the enumeration
> > process.
> >
> > This was missing from the original patch. It never produced
> > undesirable effects as it is highly improbable to have a second
> > enumeration triggered while a first one was still in progress.
> >
> > Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
> > ---
> >  drivers/hid/hid-logitech-dj.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
> > index 0d13389..d4657a5 100644
> > --- a/drivers/hid/hid-logitech-dj.c
> > +++ b/drivers/hid/hid-logitech-dj.c
> > @@ -488,6 +488,8 @@ static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev)
> >         if (djrcv_dev->querying_devices)
> >                 return 0;
> >
> > +       djrcv_dev->querying_devices = true;
> > +
> 
> Unfortunately, this breaks the fallback mechanism :(
> We tried to add the two patches in Fedora [1], but this doesn't fix
> the bug because the driver actually things that it already asked for
> the enumeration, but as we get the -EPIPE error, the request was never
> sent.
> 
> So, Jiri, if you were to submit that series to Linus (or Greg) for
> fixing the bug, please just drop this second patch.

It's already on its way to Linus (he hasn't pulled yet though) ... which 
is not a big deal per se, I can always push a revert, but I have to admit 
I don't understand the breakage it is causing at all.

Could you please elaborate? (and put an elaborate description to revert 
commit log perhaps?)

Thanks,

-- 
Jiri Kosina
SUSE Labs
