Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967288Ab3DRPTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:19:13 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:43027 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966917Ab3DRPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:19:11 -0400
Subject: Re: [Patch 1/1] cciss: bug fix, prevent cciss from loading in
 kdump kernel
From: "Mike Miller (OS Dev)" <mike.miller@hp.com>
Reply-To: mike.miller@hp.com, mikem@beardog.cce.hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20130417150227.8608817c009dad51cb5983b1@linux-foundation.org>
References: <20130415175906.GA16955@beardog.cce.hp.com>
	 <20130417150227.8608817c009dad51cb5983b1@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Apr 2013 10:19:07 -0500
Message-ID: <1366298347.11907.61.camel@thumper.usa.hp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-17 at 15:02 -0700, Andrew Morton wrote:
> On Mon, 15 Apr 2013 12:59:06 -0500 Mike Miller <mike.miller@hp.com> wrote:
> 
> > Patch 1/1
> > 
> > If hpsa is selected as the Smart Array driver cciss may try to load in the
> > kdump kernel. When this happens kdump fails and a core file cannot be created.
> > This patch prevents cciss from trying to load in this scenario. This effects
> > primarily older Smart Array controllers.
> > 
> > ...
> >
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -4960,6 +4960,12 @@ static int cciss_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >  	ctlr_info_t *h;
> >  	unsigned long flags;
> >  
> > +	/*
> > +	 * if this is the kdump kernel and the user has set the flags to
> > +	 * use hpsa rather than cciss just bail
> > +	 */
> > +	if ((reset_devices) && (cciss_allow_hpsa == 1))
> > +		return -ENODEV;
> 
> OK, wazzup.  That's the only occurrence of the symbol
> "cciss_allow_hpsa" in Linux and needless to say, the compiler laughed
> at me.

Argh. Sorry about that. I could have sworn I tested that on rc7. I'll
have another patch ready in a bit to add the flag.

> 


