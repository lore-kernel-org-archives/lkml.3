Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaGAGuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 02:50:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbaGAGua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 02:50:30 -0400
Date: Tue, 1 Jul 2014 08:50:22 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nicholas Krause <xerofoify@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hid-appleir: Fix kernel panic due to null pointer
Message-ID: <20140701065021.GA887@mguzik.redhat.com>
References: <1404180865-3681-1-git-send-email-xerofoify@gmail.com>
 <alpine.LNX.2.00.1407010837370.1655@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1407010837370.1655@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 08:39:06AM +0200, Jiri Kosina wrote:
> On Mon, 30 Jun 2014, Nicholas Krause wrote:
> 
> > Fixes a null pointer in appleir_input_configured due to reading
> > into wrong size array. Changed the variable to input_dev->keycodemax.
> 
> This is a stale changelog from the previous buggy version.
> 
> > Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> > ---
> >  drivers/hid/hid-appleir.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/hid/hid-appleir.c b/drivers/hid/hid-appleir.c
> > index 0e6a42d..cc02df4 100644
> > --- a/drivers/hid/hid-appleir.c
> > +++ b/drivers/hid/hid-appleir.c
> > @@ -272,7 +272,7 @@ static void appleir_input_configured(struct hid_device *hid,
> >  	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
> >  
> >  	memcpy(appleir->keymap, appleir_key_table, sizeof(appleir->keymap));
> > -	for (i = 0; i < ARRAY_SIZE(appleir_key_table); i++)
> > +	for (i = 0; i < appleir->keymap; i++)
> 
> This is wrong. appleir->keymap is an array, and you want to count its 
> elements.
> 

But where the claim of 'null pointer' is coming from (or reading/writing
past the array for that matter)?

Replacing appleir_key_table with appleir->keymap is a noop anyway
because:
unsigned short keymap[ARRAY_SIZE(appleir_key_table)];

although one may argue is slightly nicer since it is used in memcpy line
earlier.
-- 
Mateusz Guzik
