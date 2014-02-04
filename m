Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936368AbaBDWuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:50:25 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:60826 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932288AbaBDWuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:50:21 -0500
Message-ID: <1391554218.13156.24.camel@x220>
Subject: Re: [PATCH 1/2] raw: test against runtime value of max_raw_minors
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Kara <jack@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Date: Tue, 04 Feb 2014 23:50:18 +0100
In-Reply-To: <20140204223419.GB2696@kroah.com>
References: <1391552592.13156.15.camel@x220>
	 <20140204223419.GB2696@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Feb 2014 22:50:18.0983 (UTC) FILETIME=[7A536F70:01CF21FB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Jan Kara.]

On Tue, 2014-02-04 at 14:34 -0800, Greg Kroah-Hartman wrote:
> On Tue, Feb 04, 2014 at 11:23:12PM +0100, Paul Bolle wrote:
> > bind_get() checks the device number it is called with. It uses
> > MAX_RAW_MINORS for the upper bound. But MAX_RAW_MINORS is set at compile
> > time while the actual number of raw devices can be set at runtime. This
> > means the test can either be too strict or too lenient. And if the test
> > ends up being too lenient bind_get() might try to access memory beyond
> > what was allocated for "raw_devices".
> > 
> > So check against the runtime value (max_raw_minors) in this function.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> >  drivers/char/raw.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/raw.c b/drivers/char/raw.c
> > index f3223aa..6e8d65e 100644
> > --- a/drivers/char/raw.c
> > +++ b/drivers/char/raw.c
> > @@ -190,7 +190,7 @@ static int bind_get(int number, dev_t *dev)
> >  	struct raw_device_data *rawdev;
> >  	struct block_device *bdev;
> >  
> > -	if (number <= 0 || number >= MAX_RAW_MINORS)
> > +	if (number <= 0 || number >= max_raw_minors)
> 
> Are you sure?  For some reason, I thought this was changed to be this
> way a long time ago, can you please dig through the git archives, and
> even the history.git tree, to verify that this is correct and you aren't
> just making this be as it was before?

What apparently happened was that in v3.0, through commit 0078bff5283d
("Allow setting of number of raw devices as a module parameter"), the
test in bind_set() was updated but the test in bind_get() not.

You can - sort of - see this by comparing
    git grep -nwi max_raw_minors 0078bff5283d^

and
    git grep -nwi max_raw_minors 0078bff5283d

 

Paul Bolle

