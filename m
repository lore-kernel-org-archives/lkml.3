Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaLSKht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 05:37:49 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:53780 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbaLSKhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 05:37:48 -0500
Date: Fri, 19 Dec 2014 12:37:16 +0200
From: Aapo Vienamo <aapo.vienamo@iki.fi>
To: Jeremiah Mahler <jmmahler@gmail.com>, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix redundant parens in return in
 amplc_dio200_common.c
Message-ID: <20141219103716.GA14738@straylight.lan>
References: <1418916772-24778-1-git-send-email-aapo.vienamo@iki.fi>
 <20141218224501.GC6742@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218224501.GC6742@hudson.localdomain>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 88.112.32.252
X-SA-Exim-Mail-From: aapo.vienamo@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 02:45:01PM -0800, Jeremiah Mahler wrote:
> Aapo,
> 
> On Thu, Dec 18, 2014 at 05:32:52PM +0200, Aapo Vienamo wrote:
> > This patch fixes a coding style issue found by the checkpatch.pl tool in
> > amplc_dio200_common.c by removing the unnecessary parentheses around the
> > expression in a return statement.
> > 
> > Signed-off-by: Aapo Vienamo <aapo.vienamo@iki.fi>
> > ---
> >  drivers/staging/comedi/drivers/amplc_dio200_common.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/comedi/drivers/amplc_dio200_common.c b/drivers/staging/comedi/drivers/amplc_dio200_common.c
> > index 26aad70..6eadbbe 100644
> > --- a/drivers/staging/comedi/drivers/amplc_dio200_common.c
> > +++ b/drivers/staging/comedi/drivers/amplc_dio200_common.c
> > @@ -340,7 +340,7 @@ static int dio200_handle_read_intr(struct comedi_device *dev,
> >  
> >  	comedi_handle_events(dev, s);
> >  
> > -	return (triggered != 0);
> > +	return triggered != 0;
> >  }
> >  
> [...]
> 
> When I run checkpatch.pl it doesn't find any errors and the parenthesis
> haven't been removed.  How are you running checkpatch.pl?  Are you using
> any extra options?

It looks like that I accidentally ran the file trough an older version
of checkpatch.pl. The error for this case was quieted in commit 
5b9553a (checkpatch: make "return is not a function" test quieter).

Sorry for the noise.

- Aapo Vienamo
