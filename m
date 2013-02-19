Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab3BSR56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:57:58 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43076 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025Ab3BSR54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:57:56 -0500
Date: Tue, 19 Feb 2013 11:33:50 -0600
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com
Subject: Re: [PATCHv2 1/1] block: IBM RamSan 70/80 driver fixes.
Message-ID: <20130219173350.GB21104@oc6784271780.ibm.com>
References: <20130219164811.GA21104@oc6784271780.ibm.com>
 <1361293029.2360.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361293029.2360.4.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021917-5806-0000-0000-00001FD7E78E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the response.

Comments inline.

On Tue, Feb 19, 2013 at 08:57:09AM -0800, Joe Perches wrote:
> On Tue, 2013-02-19 at 10:48 -0600, Philip J. Kelleher wrote:
> > From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> > 
> > This patch include a few driver fixes for the IBM RamSan 70/80 driver.
> 
> trivial comments:
> 
> > diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/config.c linux-block/drivers/block/rsxx/config.c
> []
> > @@ -161,6 +161,17 @@ irqreturn_t rsxx_isr(int irq, void *pdat
> >  }
> >  
> >  /*----------------- Card Event Handler -------------------*/
> > +static char *rsxx_card_state_to_str(unsigned int state)
> 
> static const char *
> 

Ok.

> > +{
> > +	static char *state_strings[] = {
> 
> static const char * const state_strings[] = {
> 

Ok.

> > +		"Unknown", "Shutdown", "Starting", "Formatting",
> > +		"Uninitialized", "Good", "Shutting Down",
> > +		"Fault", "Read Only Fault", "dStroying"
> > +	};
> 
> []
> 
> > @@ -390,8 +391,13 @@ static int __issue_creg_rw(struct rsxx_c
> >  	if (st)
> >  		return st;
> >  
> > +	/*
> > +	 * This timeout is neccessary for unresponsive hardware. The additional
> 
> One "c" in necessary
> 

Haha... Oops. Thanks.

> > +	 * 20 seconds to used to guarantee that each cregs requests has time to
> > +	 * complete.
> > +	 */
> >  	timeout = msecs_to_jiffies((CREG_TIMEOUT_MSEC *
> > -				    card->creg_ctrl.q_depth) + 20000);
> > +				card->creg_ctrl.q_depth) + 20000);
> 
> The alignment was nicer before this change.
> Still using unnecessary parentheses.
> 
> 

Agreed.

