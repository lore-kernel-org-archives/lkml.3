Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbaBEULe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:11:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbaBEUL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:11:28 -0500
Date: Wed, 5 Feb 2014 21:11:26 +0100
From: Jan Kara <jack@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Kara <jack@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] raw: test against runtime value of max_raw_minors
Message-ID: <20140205201126.GB31318@quack.suse.cz>
References: <1391552592.13156.15.camel@x220>
 <20140204223419.GB2696@kroah.com>
 <1391554218.13156.24.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391554218.13156.24.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-02-14 23:50:18, Paul Bolle wrote:
> [Added Jan Kara.]
> 
> On Tue, 2014-02-04 at 14:34 -0800, Greg Kroah-Hartman wrote:
> > On Tue, Feb 04, 2014 at 11:23:12PM +0100, Paul Bolle wrote:
> > > bind_get() checks the device number it is called with. It uses
> > > MAX_RAW_MINORS for the upper bound. But MAX_RAW_MINORS is set at compile
> > > time while the actual number of raw devices can be set at runtime. This
> > > means the test can either be too strict or too lenient. And if the test
> > > ends up being too lenient bind_get() might try to access memory beyond
> > > what was allocated for "raw_devices".
> > > 
> > > So check against the runtime value (max_raw_minors) in this function.
> > > 
> > > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > > ---
> > >  drivers/char/raw.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/char/raw.c b/drivers/char/raw.c
> > > index f3223aa..6e8d65e 100644
> > > --- a/drivers/char/raw.c
> > > +++ b/drivers/char/raw.c
> > > @@ -190,7 +190,7 @@ static int bind_get(int number, dev_t *dev)
> > >  	struct raw_device_data *rawdev;
> > >  	struct block_device *bdev;
> > >  
> > > -	if (number <= 0 || number >= MAX_RAW_MINORS)
> > > +	if (number <= 0 || number >= max_raw_minors)
> > 
> > Are you sure?  For some reason, I thought this was changed to be this
> > way a long time ago, can you please dig through the git archives, and
> > even the history.git tree, to verify that this is correct and you aren't
> > just making this be as it was before?
> 
> What apparently happened was that in v3.0, through commit 0078bff5283d
> ("Allow setting of number of raw devices as a module parameter"), the
> test in bind_set() was updated but the test in bind_get() not.
> 
> You can - sort of - see this by comparing
>     git grep -nwi max_raw_minors 0078bff5283d^
> 
> and
>     git grep -nwi max_raw_minors 0078bff5283d
  Yeah, that was clearly an ommision on my side. Thanks for the fix!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
