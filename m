Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbbAETPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:15:33 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:55376 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbbAETPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:15:31 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        silverhammermba@gmail.com
Subject: Re: [PATCH 2/2] input: synaptics - fix width calculation on image sensors
Date: Mon, 05 Jan 2015 20:15:28 +0100
Message-ID: <3368304.jm6jgTz8dd@xps13>
In-Reply-To: <3ACB879C-A553-49A0-B170-CFF14A494BEE@gmail.com>
References: <1419679889-6582-1-git-send-email-gabriele.mzt@gmail.com> <CAN+gG=FLOD5C3N0q-i=4Sm6fH+oYTV27nEOKn8nxaw7GvFJbkQ@mail.gmail.com> <3ACB879C-A553-49A0-B170-CFF14A494BEE@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2015 11:04:07 Dmitry Torokhov wrote:
> On January 5, 2015 10:42:13 AM PST, Benjamin Tissoires <benjamin.tissoires@gmail.com> wrote:
> >On Mon, Jan 5, 2015 at 1:37 PM, Gabriele Mazzotta
> ><gabriele.mzt@gmail.com> wrote:
> >> On Monday 05 January 2015 13:25:38 Benjamin Tissoires wrote:
> >>> Hi Gabriele,
> >>>
> >>> On Sat, Dec 27, 2014 at 6:31 AM, Gabriele Mazzotta
> >>> <gabriele.mzt@gmail.com> wrote:
> >>> > When two or more fingers are on the touchpad, the 'w' slot holds
> >the
> >>> > finger count rather than the width. Retrieve the correct value
> >encoded
> >>> > in the lower bits of 'x', 'y' and 'z'.
> >>> >
> >>> > The minimum width reported is 8 rather than 4 in this case, while
> >the
> >>> > maximum remains 15.
> >>> >
> >>> > Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
> >>> > ---
> >>> >  drivers/input/mouse/synaptics.c | 4 +++-
> >>> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >>> >
> >>> > diff --git a/drivers/input/mouse/synaptics.c
> >b/drivers/input/mouse/synaptics.c
> >>> > index ea0563e..5ff4c5b 100644
> >>> > --- a/drivers/input/mouse/synaptics.c
> >>> > +++ b/drivers/input/mouse/synaptics.c
> >>> > @@ -593,7 +593,9 @@ static void synaptics_parse_agm(const unsigned
> >char buf[],
> >>> >         switch (agm_packet_type) {
> >>> >         case 1:
> >>> >                 /* Gesture packet: (x, y, z) half resolution */
> >>> > -               agm->w = hw->w;
> >>> > +               agm->w = ((buf[1] & 0x01) |
> >>> > +                         ((buf[2] & 0x01) << 1) |
> >>> > +                         ((buf[5] & 0x01) << 2)) + 8;
> >>> >                 agm->x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
> >>>
> >>> For completeness, I think, we should also removes the w bits from x,
> >y
> >>> and z (by masking buf[1], buf[2] and buf[5] with 0xfe).
> >>
> >> You are right, I forgot about it.
> >>
> >> I was going to re-submit these patches anyway since there have been
> >> quite a few changes and these can no longer be applied on next.
> >
> >OK, I am trying to put together my thoughts for 1/2 right now. If you
> >could just wait a little before resubmitting, I would be grateful.
> >
> 
> BTW, do we really get different widths four different contacts?
> 
> Thanks.

I think that only the width of the last finger that was laid on the
touchpad is reported.
