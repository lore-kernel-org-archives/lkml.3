Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab3FGFeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:34:12 -0400
Received: from 1wt.eu ([62.212.114.60]:36086 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3FGFeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:34:10 -0400
Date: Fri, 7 Jun 2013 07:34:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Connor <sconnor004@allyinics.org>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 044/184] ALSA: ice1712: Initialize card->private_data
Message-ID: <20130607053401.GE14633@1wt.eu>
References: <20130604172132.135940874@1wt.eu> <1370576938.4021.66.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370576938.4021.66.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Fri, Jun 07, 2013 at 04:48:58AM +0100, Ben Hutchings wrote:
> > From: Sean Connor <sconnor004@allyinics.org>
> > 
> > commit 69a4cfdd444d1fe5c24d29b3a063964ac165d2cd upstream.
> > 
> > Set card->private_data in snd_ice1712_create for fixing NULL
> > dereference in snd_ice1712_remove().
> 
> This bug appears to have been introduced in Linux 3.8 and doesn't need
> fixing in 2.6.32.

Ah indeed that's true. Does it harm to have it or not ? because I'm
still seeing a number of places where we have this in the driver :

   struct snd_ice1712 *ice = ac97->private_data;

I'd like to be sure that no other function risks to dereference the
same pointer. Also, I'm noting that 3.0/3.4 have this fix, while 3.2
does not. So I'm hesitant what to do with this patch.

Thanks,
Willy

