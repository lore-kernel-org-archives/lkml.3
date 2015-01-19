Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbbASMUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:20:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41035 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbbASMU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:20:28 -0500
Date: Mon, 19 Jan 2015 15:19:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Robin Schroer <sulamiification@gmail.com>
Cc: Shirish Gajera <gajerashirish@gmail.com>, devel@driverdev.osuosl.org,
        kirk@reisers.ca, gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        rusty@rustcorp.com.au, speakup@linux-speakup.org,
        aysemelikeyurtoglu@gmail.com, linux-kernel@vger.kernel.org,
        domagoj.trsan@gmail.com, roxanagabriela10@gmail.com,
        tapaswenipathak@gmail.com, samuel.thibault@ens-lyon.org,
        dilekuzulmez@gmail.com, ben@decadent.org.uk, sasha.levin@oracle.com,
        chris@the-brannons.com
Subject: Re: [PATCH] staging: speakup: Fix warning of line over 80 characters.
Message-ID: <20150119121934.GA6456@mwanda>
References: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
 <20150118082921.GB1150@shodan.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150118082921.GB1150@shodan.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 09:29:21AM +0100, Robin Schroer wrote:
> On Sat, Jan 17, 2015 at 11:57:53PM -0800, Shirish Gajera wrote:
> > diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
> > index e9f0c15..141abb7 100644
> > --- a/drivers/staging/speakup/main.c
> > +++ b/drivers/staging/speakup/main.c
> > @@ -422,8 +422,10 @@ static void announce_edge(struct vc_data *vc, int msg_id)
> >  {
> >  	if (spk_bleeps & 1)
> >  		bleep(spk_y);
> > -	if ((spk_bleeps & 2) && (msg_id < edge_quiet))
> > -		synth_printf("%s\n", spk_msg_get(MSG_EDGE_MSGS_START + msg_id - 1));
> > +	if ((spk_bleeps & 2) && (msg_id < edge_quiet)) {
> > +		synth_printf("%s\n",
> > +		spk_msg_get(MSG_EDGE_MSGS_START + msg_id - 1));
> > +	}
> >  }
> >  
> You do not actually need to add the braces as this remains a single
> statement (mnemonic: without braces the if ends at the first semicolon).
> 

In staging (and most other trees), we prefer that the curly braces be
there for multi-line indents.  It makes it more readable.

regards,
dan carpenter

