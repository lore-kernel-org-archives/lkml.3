Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbaAFXFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:05:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322AbaAFXFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 18:05:13 -0500
Date: Mon, 6 Jan 2014 15:05:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.4 22/43] tg3: Expand 4g_overflow_test workaround to skb
 fragments of any size.
Message-ID: <20140106230539.GA27291@kroah.com>
References: <20140106223942.259651490@linuxfoundation.org>
 <20140106223942.884336164@linuxfoundation.org>
 <1389049135.26646.14.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389049135.26646.14.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 02:58:55PM -0800, Eric Dumazet wrote:
> On Mon, 2014-01-06 at 14:39 -0800, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Nithin Sujir <nsujir@broadcom.com>
> > 
> > commit 375679104ab3ccfd18dcbd7ba503734fb9a2c63a upstream.
> > 
> > The current driver assumes that an skb fragment can only be upto jumbo
> > size. Presumably this was a fast-path optimization. This assumption is
> > no longer true as fragments can be upto 32k.
> > 
> > v2: Remove unnecessary parantheses per Eric Dumazet.
> > 
> > Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
> > Signed-off-by: Michael Chan <mchan@broadcom.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  drivers/net/ethernet/broadcom/tg3.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/drivers/net/ethernet/broadcom/tg3.c
> > +++ b/drivers/net/ethernet/broadcom/tg3.c
> > @@ -6619,7 +6619,7 @@ static inline int tg3_4g_overflow_test(d
> >  {
> >  	u32 base = (u32) mapping & 0xffffffff;
> >  
> > -	return (base > 0xffffdcc0) && (base + len + 8 < base);
> > +	return base + len + 8 < base;
> >  }
> >  
> 
> Minor comment :
> 
> 32KB frags were added later, in 3.7.
> 
> This patch makes no harm, so no worries.

Ah, thanks, I'll go drop it anyway.

greg k-h
