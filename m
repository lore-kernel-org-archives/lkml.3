Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab3CRFfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 01:35:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3CRFfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 01:35:41 -0400
Date: Mon, 18 Mar 2013 13:35:19 +0800
From: Asias He <asias@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 04/21] target/pscsi: Fix page increment
Message-ID: <20130318053519.GE6232@hj.localdomain>
References: <20130312223245.109098379@linuxfoundation.org>
 <20130312223245.664885170@linuxfoundation.org>
 <1363399822.3937.161.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363399822.3937.161.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 02:10:22AM +0000, Ben Hutchings wrote:
> On Tue, 2013-03-12 at 15:44 -0700, Greg Kroah-Hartman wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Asias He <asias@redhat.com>
> > 
> > commit 472b72f2db7831d7dbe22ffdff4adee3bd49b05d upstream.
> > 
> > The page++ is wrong. It makes bio_add_pc_page() pointing to a wrong page
> > address if the 'while (len > 0 && data_len > 0) { ... }' loop is
> > executed more than one once.
> > 
> > Signed-off-by: Asias He <asias@redhat.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  drivers/target/target_core_pscsi.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > --- a/drivers/target/target_core_pscsi.c
> > +++ b/drivers/target/target_core_pscsi.c
> > @@ -1210,7 +1210,6 @@ static int __pscsi_map_task_SG(
> >  				bio = NULL;
> >  			}
> >  
> > -			page++;
> >  			len -= bytes;
> >  			data_len -= bytes;
> >  			off = 0;
> 
> So in case a fragment crosses a page boundary, we wrap around to the
> beginning of the same page?  That doesn't look right.

If the fragment crosses a page boundary, what is the correct page
for it?

Nicholas, can we assume sg->length + sg->offset should be less than PAGE_SIZE here?

> Ben.
> 
> -- 
> Ben Hutchings
> It is easier to change the specification to fit the program than vice versa.

-- 
Asias
