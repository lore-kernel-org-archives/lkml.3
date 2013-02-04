Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3BDJel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:34:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab3BDJek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:34:40 -0500
Date: Mon, 4 Feb 2013 10:34:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/9] HID: core: add "report" hook, called once the
 report has been parsed
In-Reply-To: <20130203122748.GA2513@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1302041033500.26996@pobox.suse.cz>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com> <1359649351-11092-2-git-send-email-benjamin.tissoires@gmail.com> <20130203122748.GA2513@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Feb 2013, Henrik Rydberg wrote:

> > This callback is called when the parsing of the report has been done
> > by hid-core (so after the calls to .event). The hid drivers can now
> > have access to the whole report by relying on the values stored in
> > the different fields.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > ---
> >  drivers/hid/hid-core.c | 4 ++++
> >  include/linux/hid.h    | 2 ++
> >  2 files changed, 6 insertions(+)
> > 
> > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > index 5ae2cb1..b671e4e 100644
> > --- a/drivers/hid/hid-core.c
> > +++ b/drivers/hid/hid-core.c
> > @@ -1195,6 +1195,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
> >  {
> >  	struct hid_report_enum *report_enum = hid->report_enum + type;
> >  	struct hid_report *report;
> > +	struct hid_driver *hdrv;
> >  	unsigned int a;
> >  	int rsize, csize = size;
> >  	u8 *cdata = data;
> > @@ -1231,6 +1232,9 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
> >  	if (hid->claimed != HID_CLAIMED_HIDRAW) {
> >  		for (a = 0; a < report->maxfield; a++)
> >  			hid_input_field(hid, report->field[a], cdata, interrupt);
> > +		hdrv = hid->driver;
> > +		if (hdrv && hdrv->report)
> > +			hdrv->report(hid, report);
> 
> I think this is more useful if called before the individual fields. In
> fact, it seems raw_event() is already doing exactly that. No need for
> a new callback, in other words.

raw_event() doesn't provide equivalent functionality though; namely, the 
report is not parsed.

Or have I missed your point?

Thanks for the extensive review, Henrik, it's really helpful.

-- 
Jiri Kosina
SUSE Labs
