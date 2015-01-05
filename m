Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbbAETES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:04:18 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33060 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbbAETEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:04:16 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAN+gG=FLOD5C3N0q-i=4Sm6fH+oYTV27nEOKn8nxaw7GvFJbkQ@mail.gmail.com>
References: <1419679889-6582-1-git-send-email-gabriele.mzt@gmail.com> <1419679889-6582-3-git-send-email-gabriele.mzt@gmail.com> <CAN+gG=FmtDcMQR0RzNwdy65riaL=hF5F18opwUTJV-oPESJ5JA@mail.gmail.com> <4167786.IbP0CPQIld@xps13> <CAN+gG=FLOD5C3N0q-i=4Sm6fH+oYTV27nEOKn8nxaw7GvFJbkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 2/2] input: synaptics - fix width calculation on image sensors
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 05 Jan 2015 11:04:07 -0800
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        silverhammermba@gmail.com
Message-ID: <3ACB879C-A553-49A0-B170-CFF14A494BEE@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On January 5, 2015 10:42:13 AM PST, Benjamin Tissoires <benjamin.tissoires@gmail.com> wrote:
>On Mon, Jan 5, 2015 at 1:37 PM, Gabriele Mazzotta
><gabriele.mzt@gmail.com> wrote:
>> On Monday 05 January 2015 13:25:38 Benjamin Tissoires wrote:
>>> Hi Gabriele,
>>>
>>> On Sat, Dec 27, 2014 at 6:31 AM, Gabriele Mazzotta
>>> <gabriele.mzt@gmail.com> wrote:
>>> > When two or more fingers are on the touchpad, the 'w' slot holds
>the
>>> > finger count rather than the width. Retrieve the correct value
>encoded
>>> > in the lower bits of 'x', 'y' and 'z'.
>>> >
>>> > The minimum width reported is 8 rather than 4 in this case, while
>the
>>> > maximum remains 15.
>>> >
>>> > Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
>>> > ---
>>> >  drivers/input/mouse/synaptics.c | 4 +++-
>>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>>> >
>>> > diff --git a/drivers/input/mouse/synaptics.c
>b/drivers/input/mouse/synaptics.c
>>> > index ea0563e..5ff4c5b 100644
>>> > --- a/drivers/input/mouse/synaptics.c
>>> > +++ b/drivers/input/mouse/synaptics.c
>>> > @@ -593,7 +593,9 @@ static void synaptics_parse_agm(const unsigned
>char buf[],
>>> >         switch (agm_packet_type) {
>>> >         case 1:
>>> >                 /* Gesture packet: (x, y, z) half resolution */
>>> > -               agm->w = hw->w;
>>> > +               agm->w = ((buf[1] & 0x01) |
>>> > +                         ((buf[2] & 0x01) << 1) |
>>> > +                         ((buf[5] & 0x01) << 2)) + 8;
>>> >                 agm->x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
>>>
>>> For completeness, I think, we should also removes the w bits from x,
>y
>>> and z (by masking buf[1], buf[2] and buf[5] with 0xfe).
>>
>> You are right, I forgot about it.
>>
>> I was going to re-submit these patches anyway since there have been
>> quite a few changes and these can no longer be applied on next.
>
>OK, I am trying to put together my thoughts for 1/2 right now. If you
>could just wait a little before resubmitting, I would be grateful.
>

BTW, do we really get different widths four different contacts?

Thanks.

-- 
Dmitry
