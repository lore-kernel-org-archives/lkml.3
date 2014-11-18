Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaKRVuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:50:51 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34752 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbaKRVut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:50:49 -0500
Date: Tue, 18 Nov 2014 22:50:45 +0100
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] staging: panel: Use a macro for checking module
 params state
Message-ID: <20141118215044.GB10306@firebird>
References: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com>
 <1416344174-9155-5-git-send-email-marius.gorski@gmail.com>
 <20141118211844.GG26514@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118211844.GG26514@1wt.eu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 10:18:44PM +0100, Willy Tarreau wrote:
> On Tue, Nov 18, 2014 at 09:56:09PM +0100, Mariusz Gorski wrote:
> > Avoid values comparison and use a macro instead that checks
> > whether module param has been set by the user to some value
> > at loading time.
> > 
> > Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> > ---
> >  drivers/staging/panel/panel.c | 88 ++++++++++++++++++++++---------------------
> >  1 file changed, 45 insertions(+), 43 deletions(-)
> > 
> > diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> > index 1b4a211..97fc4ca 100644
> > --- a/drivers/staging/panel/panel.c
> > +++ b/drivers/staging/panel/panel.c
> > @@ -135,6 +135,8 @@
> >  
> >  #define NOT_SET			-1
> >  
> > +#define IS_NOT_SET(x)	(x == NOT_SET)
> > +
> >  /* macros to simplify use of the parallel port */
> >  #define r_ctr(x)        (parport_read_control((x)->port))
> >  #define r_dtr(x)        (parport_read_data((x)->port))
> > @@ -1411,29 +1413,29 @@ static void lcd_init(void)
> >  	switch (lcd_type) {
> >  	case LCD_TYPE_OLD:
> >  		/* parallel mode, 8 bits */
> > -		if (lcd_proto < 0)
> > +		if (IS_NOT_SET(lcd_proto))
> >  			lcd_proto = LCD_PROTO_PARALLEL;
> > -		if (lcd_charset < 0)
> > +		if (IS_NOT_SET(lcd_charset))
> >  			lcd_charset = LCD_CHARSET_NORMAL;
> >  		if (lcd_e_pin == PIN_NOT_SET)
> >  			lcd_e_pin = PIN_STROBE;
> >  		if (lcd_rs_pin == PIN_NOT_SET)
> >  			lcd_rs_pin = PIN_AUTOLF;
> >  
> > -		if (lcd_width < 0)
> > +		if (IS_NOT_SET(lcd_width))
> >  			lcd_width = 40;
> (...)
> 
> I'm not convinced at all by the increased readability of this one.
> To me it adds obfuscation since I have to look for the macro definition
> to see how it checks whether the type is set or not.
> 
> I think you'd rather simply open-code the macro here and keep the natural
> comparison. The fields were already initialized to the NOT_SET value, better
> check agaist the same value here especially since it matches other tests as
> well. That would give :
> 
> -		if (lcd_proto < 0)
> +		if (lcd_proto == NOT_SET)
>   			lcd_proto = LCD_PROTO_PARALLEL;
> 
> etc...  To me it's more readable.
> 
> Willy
>
Hmm ok maybe you're right, maybe I've tried to hide too much here.
"x == NOT_SET" hides already enough ;) I'll fix that.

Thanks,
Mariusz
