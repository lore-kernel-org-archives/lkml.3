Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaKRVul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:50:41 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:32942 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbaKRVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:50:40 -0500
Date: Tue, 18 Nov 2014 22:50:35 +0100
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] staging: panel: Make two more module params read-only
Message-ID: <20141118215034.GA10306@firebird>
References: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com>
 <1416344174-9155-7-git-send-email-marius.gorski@gmail.com>
 <20141118212034.GI26514@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118212034.GI26514@1wt.eu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 10:20:34PM +0100, Willy Tarreau wrote:
> On Tue, Nov 18, 2014 at 09:56:11PM +0100, Mariusz Gorski wrote:
> > Make keypad_type and lcd_type module params read-only.
> > This step also starts making it more clear what is
> > the precedence of device params coming from different
> > sources (device profile, runtime module param values etc).
> > 
> > Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> > ---
> >  drivers/staging/panel/panel.c | 71 ++++++++++++++++++++++---------------------
> >  1 file changed, 37 insertions(+), 34 deletions(-)
> > 
> > diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> > index 7f2f5f8..5b4f0a4 100644
> > --- a/drivers/staging/panel/panel.c
> > +++ b/drivers/staging/panel/panel.c
> > @@ -229,6 +229,9 @@ static struct {
> >  	bool enabled;
> >  } lcd;
> >  
> > +/* Needed only for init */
> > +static int selected_lcd_type = NOT_SET;
> > +
> >  /* contains the LCD config state */
> >  static unsigned long int lcd_flags;
> >  /* contains the LCD X offset */
> > @@ -1417,7 +1420,7 @@ static void panel_lcd_print(const char *s)
> >  /* initialize the LCD driver */
> >  static void lcd_init(void)
> >  {
> > -	switch (lcd_type) {
> > +	switch (selected_lcd_type) {
> 
> (...)
> 
> stupid question : why not move that to the lcd struct you just
> created instead of creating a new variable ? It would make sense
> to me to have lcd.type here just like you did with enabled.
> Same for keypad.
> 
> Willy
>

I get your point here. This var is here only because it's set
in init_panel_module() and then used in lcd_init(). So it's needed
really only for the init code. It doesn't directly_ describe the 
lcd's state, so I decided to keep it out.

Thanks,
Mariusz
