Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaIBNSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:18:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52250 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaIBNSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:18:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 2 Sep 2014 15:18:19 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Sander Nemvalts <snemvalts@gmail.com>, Paul Bolle <pebolle@tiscali.nl>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:firewire: fix style errors in core-card.c This
 is a patch in the core-card.c file which fixes up 2 warnings found by the
 checkpatch.pl tool Signed-off-by: Sander Nemvalts <snemvalts@gmail.com>
Message-ID: <20140902151819.29c3f154@kant>
In-Reply-To: <CAAagr2=oG7dyKMBW0DZAJLDoW+2k=vFYADv-JVC6Q2sr7tEYcQ@mail.gmail.com>
References: <1409597306-22164-1-git-send-email-snemvalts@gmail.com>
	<20140901235605.5466b6a6@kant>
	<CAAagr2=oG7dyKMBW0DZAJLDoW+2k=vFYADv-JVC6Q2sr7tEYcQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folding two replies into one.

On Sep 02 Sander Nemvalts wrote:
> On Sep 2, 2014 12:56 AM, "Stefan Richter" <stefanr@s5r6.in-berlin.de> wrote:
> 
> > On Sep 01 Sander Nemvalts wrote:
> > > --- a/drivers/firewire/core-card.c
> > > +++ b/drivers/firewire/core-card.c
> > > @@ -89,7 +89,8 @@ static size_t config_rom_length = 1 + 4 + 1 + 1;
> > >  #define BIB_ISC                      ((1) << 29)
> > >  #define BIB_CMC                      ((1) << 30)
> > >  #define BIB_IRMC             ((1) << 31)
> > > -#define NODE_CAPABILITIES    0x0c0083c0 /* per IEEE 1394 clause 8.3.2.6.5.2 */
> > > +/* per IEEE 1394 clause 8.3.2.6.5.2 */
> > > +#define NODE_CAPABILITIES    0x0c0083c0
> >
> > This is no improvement.
> >
> The comment after NODE_CAPABILITIES was moved to front of statement because
> the line would otherwise be over 80 characters long.

There is no problem with this line's remaining 81 characters long.

> Also, commenting before the line is demonstrated in the next statement.

This block of statements is entirely unrelated to the next statement;
furthermore the nature and form of this and the next comment are unrelated.


On Sep 02 Paul Bolle wrote:
> On Mon, 2014-09-01 at 23:56 +0200, Stefan Richter wrote:
> > On Sep 01 Sander Nemvalts wrote:
> > > @@ -132,7 +133,7 @@ static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
> > >  	j = 7 + descriptor_count;
> > >  
> > >  	/* Generate root directory entries for descriptors. */
> > > -	list_for_each_entry (desc, &descriptor_list, link) {
> > > +	list_for_each_entry(desc, &descriptor_list, link) {
> > >  		if (desc->immediate > 0)
> > >  			config_rom[i++] = cpu_to_be32(desc->immediate);
> > >  		config_rom[i] = cpu_to_be32(desc->key | (j - i));
> > 
> > We are writing
> > 	for (a; b; c);
> > not
> > 	for(a; b; c);
> > and thus a space after list_for_each and friends makes sense.
> 
> $ git grep "list_for_each_entry (" | wc -l
> 52
> $ git grep "list_for_each_entry(" | wc -l
> 5991
> 
> So "list_for_each_entry(" (without space) seems to be the preferred
> style.

'Seems to be' is an appropriate wording indeed, since grep shows
occurrences, not preferences.


All,

here are some tips for whitespace changes and similar patches:

  - As a general rule, do not propose style changes to code on which you
    are not working on.

  - Do not propose style changes to code on which you are working on,
    unless you can significantly improve the code this way.

    Rationale:  Style changes (outside of drivers/staging/) tend to worsen
    rather than improve code.  Style changes obfuscate code history.  Style
    changes are of doubtfule value but create nonzero work for those who
    handle the code together with you or after you.

  - checkpatch.pl is a help for you to evaluate stylistic conformance of
    your own new code submissions.  Use checkpatch.pl for its original
    purpose.
-- 
Stefan Richter
-=====-====- =--= ---=-
http://arcgraph.de/sr/
