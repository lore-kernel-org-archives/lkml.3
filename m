Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030265AbaGAWV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:21:26 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:62006 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaGAWVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:21:22 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1407010852160.1655@pobox.suse.cz>
References: <1404180865-3681-1-git-send-email-xerofoify@gmail.com>
	<alpine.LNX.2.00.1407010837370.1655@pobox.suse.cz>
	<20140701065021.GA887@mguzik.redhat.com>
	<alpine.LNX.2.00.1407010852160.1655@pobox.suse.cz>
Date: Tue, 1 Jul 2014 18:21:21 -0400
Message-ID: <CAPDOMVgWweKUgW29g=xWtNJTtqbm7BB27+prW11MC4v5xZeE6g@mail.gmail.com>
Subject: Re: [PATCH v2] hid-appleir: Fix kernel panic due to null pointer
From: Nick Krause <xerofoify@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mateusz Guzik <mguzik@redhat.com>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I am wondering them should I can it to sizeof(appleir_keymap)?
Nick

On Tue, Jul 1, 2014 at 2:55 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 1 Jul 2014, Mateusz Guzik wrote:
>
>> > > Fixes a null pointer in appleir_input_configured due to reading
>> > > into wrong size array. Changed the variable to input_dev->keycodemax.
>> >
>> > This is a stale changelog from the previous buggy version.
>> >
>> > > Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> > > ---
>> > >  drivers/hid/hid-appleir.c | 2 +-
>> > >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > >
>> > > diff --git a/drivers/hid/hid-appleir.c b/drivers/hid/hid-appleir.c
>> > > index 0e6a42d..cc02df4 100644
>> > > --- a/drivers/hid/hid-appleir.c
>> > > +++ b/drivers/hid/hid-appleir.c
>> > > @@ -272,7 +272,7 @@ static void appleir_input_configured(struct hid_device *hid,
>> > >   input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
>> > >
>> > >   memcpy(appleir->keymap, appleir_key_table, sizeof(appleir->keymap));
>> > > - for (i = 0; i < ARRAY_SIZE(appleir_key_table); i++)
>> > > + for (i = 0; i < appleir->keymap; i++)
>> >
>> > This is wrong. appleir->keymap is an array, and you want to count its
>> > elements.
>> >
>>
>> But where the claim of 'null pointer' is coming from (or reading/writing
>> past the array for that matter)?
>>
>> Replacing appleir_key_table with appleir->keymap is a noop anyway
>> because:
>> unsigned short keymap[ARRAY_SIZE(appleir_key_table)];
>
> It's not really equivalent. ARRAY_SIZE counts the number of short-sized
> elements, sizeof() counts the number of bytes that fit into the data
> structure (which is twice as much, as sizeof(unsigned short) == 2).
>
> --
> Jiri Kosina
> SUSE Labs
