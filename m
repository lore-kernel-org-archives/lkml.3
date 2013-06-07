Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab3FGGWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:22:18 -0400
Received: from 1wt.eu ([62.212.114.60]:36136 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab3FGGWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:22:17 -0400
Date: Fri, 7 Jun 2013 08:22:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Sean Connor <sconnor004@allyinics.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 044/184] ALSA: ice1712: Initialize card->private_data
Message-ID: <20130607062211.GO14633@1wt.eu>
References: <20130604172132.135940874@1wt.eu> <1370576938.4021.66.camel@deadeye.wl.decadent.org.uk> <20130607053401.GE14633@1wt.eu> <s5hli6mqwju.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hli6mqwju.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Fri, Jun 07, 2013 at 08:12:05AM +0200, Takashi Iwai wrote:
> > > This bug appears to have been introduced in Linux 3.8 and doesn't need
> > > fixing in 2.6.32.
> > 
> > Ah indeed that's true. Does it harm to have it or not ?
> 
> It's harmless.
> 
> > because I'm
> > still seeing a number of places where we have this in the driver :
> > 
> >    struct snd_ice1712 *ice = ac97->private_data;
> 
> These are different object types.  The reference of card->private_data
> was introduced recently as Ben pointed out.

Ah sorry I was confused.

> > I'd like to be sure that no other function risks to dereference the
> > same pointer. Also, I'm noting that 3.0/3.4 have this fix, while 3.2
> > does not. So I'm hesitant what to do with this patch.
> 
> Just overlooked in 3.0/3.4 reviews :-<
> 
> But it's utterly harmless, we don't have to remove it from 3.0/3.4, I
> think.  
> 
> For 2.6.32, better to get rid of it from the queue, if it's not too
> late.

Perfect, thanks for the detailed explanation, I'm removing it now.

Best regards,
Willy

