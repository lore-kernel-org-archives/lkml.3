Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaCEKGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:06:37 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35904 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbaCEKGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:06:34 -0500
Date: Wed, 5 Mar 2014 10:06:03 +0000
From: Will Deacon <will.deacon@arm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "pali.rohar@gmail.com" <pali.rohar@gmail.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wl1251: use skb_trim to make skb shorter
Message-ID: <20140305100603.GA29309@mudshark.cambridge.arm.com>
References: <20140225105756.GB22279@mudshark.cambridge.arm.com>
 <1393678326-23535-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20140304142658.GK8766@mudshark.cambridge.arm.com>
 <20140304183348.GB7317@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304183348.GB7317@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 06:33:48PM +0000, John W. Linville wrote:
> OK, I'll queue it as a fix...

Thanks, John.

Will


> On Tue, Mar 04, 2014 at 02:26:58PM +0000, Will Deacon wrote:
> > Hi Jonn,
> > 
> > On Sat, Mar 01, 2014 at 12:52:06PM +0000, Ivaylo Dimitrov wrote:
> > > the current code is directly setting skb->len, which is not correct and
> > > brings problems with HAVE_EFFICIENT_UNALIGNED_ACCESS enabled in config
> > > 
> > > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > > ---
> > 
> > Can you pick this patch up please? It addresses a regression introduced in
> > the merge window (ARM started selecting HAVE_EFFICIENT_UNALIGNED_ACCESS).
> > 
> > Cheers,
> > 
> > Will
> > 
> > >  drivers/net/wireless/ti/wl1251/rx.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/wireless/ti/wl1251/rx.c b/drivers/net/wireless/ti/wl1251/rx.c
> > > index 123c4bb..cde0eaf 100644
> > > --- a/drivers/net/wireless/ti/wl1251/rx.c
> > > +++ b/drivers/net/wireless/ti/wl1251/rx.c
> > > @@ -180,7 +180,7 @@ static void wl1251_rx_body(struct wl1251 *wl,
> > >  	wl1251_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
> > >  
> > >  	/* The actual length doesn't include the target's alignment */
> > > -	skb->len = desc->length  - PLCP_HEADER_LENGTH;
> > > +	skb_trim(skb, desc->length - PLCP_HEADER_LENGTH);
> > >  
> > >  	fc = (u16 *)skb->data;
> > >  
> > > -- 
> > > 1.7.9.5
> > > 
> > > 
> > 
> 
> -- 
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
> 
