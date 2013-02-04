Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3BDJlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:41:13 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:41304 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3BDJlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:41:12 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1302041033500.26996@pobox.suse.cz>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
	<1359649351-11092-2-git-send-email-benjamin.tissoires@gmail.com>
	<20130203122748.GA2513@polaris.bitmath.org>
	<alpine.LNX.2.00.1302041033500.26996@pobox.suse.cz>
Date: Mon, 4 Feb 2013 10:41:10 +0100
Message-ID: <CAN+gG=H-wsD=RhvxttoAkWTtR2-1H1fJ8EAhpZfs9xEqSO0t7A@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] HID: core: add "report" hook, called once the
 report has been parsed
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 10:34 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sun, 3 Feb 2013, Henrik Rydberg wrote:
>
>> > This callback is called when the parsing of the report has been done
>> > by hid-core (so after the calls to .event). The hid drivers can now
>> > have access to the whole report by relying on the values stored in
>> > the different fields.
>> >
>> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> > ---
>> >  drivers/hid/hid-core.c | 4 ++++
>> >  include/linux/hid.h    | 2 ++
>> >  2 files changed, 6 insertions(+)
>> >
>> > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> > index 5ae2cb1..b671e4e 100644
>> > --- a/drivers/hid/hid-core.c
>> > +++ b/drivers/hid/hid-core.c
>> > @@ -1195,6 +1195,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>> >  {
>> >     struct hid_report_enum *report_enum = hid->report_enum + type;
>> >     struct hid_report *report;
>> > +   struct hid_driver *hdrv;
>> >     unsigned int a;
>> >     int rsize, csize = size;
>> >     u8 *cdata = data;
>> > @@ -1231,6 +1232,9 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>> >     if (hid->claimed != HID_CLAIMED_HIDRAW) {
>> >             for (a = 0; a < report->maxfield; a++)
>> >                     hid_input_field(hid, report->field[a], cdata, interrupt);
>> > +           hdrv = hid->driver;
>> > +           if (hdrv && hdrv->report)
>> > +                   hdrv->report(hid, report);
>>
>> I think this is more useful if called before the individual fields. In
>> fact, it seems raw_event() is already doing exactly that. No need for
>> a new callback, in other words.
>
> raw_event() doesn't provide equivalent functionality though; namely, the
> report is not parsed.
>
> Or have I missed your point?

No, you perfectly understood the purpose of the patch. raw_event() and
report() are not the same kind of callbacks at all.

>
> Thanks for the extensive review, Henrik, it's really helpful.

Yep, thanks Henrik, and thanks Jiri for having a look at it.

Cheers,
Benjamin
