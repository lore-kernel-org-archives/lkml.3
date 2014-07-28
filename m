Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaG1KUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:20:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34979 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaG1KUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:20:42 -0400
Date: Mon, 28 Jul 2014 12:20:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Stefan Weil <sw@weilnetz.de>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: laptops: freefall.c:  Cleaning up
 missing null-terminate in conjunction with strncpy
Message-ID: <20140728102040.GA16495@amd.pavel.ucw.cz>
References: <1406472043-12272-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <53D58550.6040205@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D58550.6040205@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-07-27 16:03:44, Randy Dunlap wrote:
> On 07/27/14 07:40, Rickard Strandqvist wrote:
> > Added a guaranteed null-terminate after call to strncpy.
> > 
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> > ---
> >  Documentation/laptops/freefall.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/laptops/freefall.c b/Documentation/laptops/freefall.c
> > index aab2ff0..113d004 100644
> > --- a/Documentation/laptops/freefall.c
> > +++ b/Documentation/laptops/freefall.c
> > @@ -33,8 +33,10 @@ static int set_unload_heads_path(char *device)
> >  
> >  	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
> >  		return -EINVAL;
> > -	strncpy(devname, device + 5, sizeof(devname) - 1);
> > -	strncpy(device_path, device, sizeof(device_path) - 1);
> 
> Maybe I am overlooking something here, but what was wrong with
> the - 1 (2 times) above?  and then just add the 2 lines below that set the
> last byte to '\0'?

Actually device_path is static, so it will be zero-initialized and
explicit set is not neccessary AFAICT.

(devname is auto -> needs explicit set).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
