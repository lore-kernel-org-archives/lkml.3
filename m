Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaDHFDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 01:03:15 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:57792 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaDHFDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 01:03:13 -0400
Date: Tue, 8 Apr 2014 07:02:59 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv3 1/3] pwm: make the PWM_POLARITY flag in DTB optional
Message-ID: <20140408070259.68923987@ipc1.ka-ro>
In-Reply-To: <20140407113652.GE26985@ulmo>
References: <1395235375-12925-1-git-send-email-LW@KARO-electronics.de>
	<1395996540-10999-1-git-send-email-LW@KARO-electronics.de>
	<1395996540-10999-2-git-send-email-LW@KARO-electronics.de>
	<20140402055350.GX17250@pengutronix.de>
	<20140407113652.GE26985@ulmo>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thierry Reding wrote:
> On Wed, Apr 02, 2014 at 07:53:50AM +0200, Sascha Hauer wrote:
> > On Fri, Mar 28, 2014 at 09:48:58AM +0100, Lothar Waßmann wrote:
> [...]
> > > @@ -183,8 +173,11 @@ static void of_pwmchip_add(struct pwm_chip *chip)
> > >  		return;
> > >  
> > >  	if (!chip->of_xlate) {
> > > -		chip->of_xlate = of_pwm_simple_xlate;
> > > -		chip->of_pwm_n_cells = 2;
> > > +		chip->of_xlate = of_pwm_xlate;
> > > +		if (chip->ops->set_polarity)
> > > +			chip->of_pwm_n_cells = 3;
> > > +		else
> > > +			chip->of_pwm_n_cells = 2;
> > 
> > I think the presence of the set_polarity callback shouldn't influence
> > the number of cells the parser expects. As commented on 2/2 this doesn't
> > actually mean the device actually support polarity inversion.
> 
> How so? A driver should only implement .set_polarity() if it supports
> changing the polarity.
> 
> That said, I agree that the presence of .set_polarity() shouldn't
> determine the number of cells. You could have any number of other flags
> set via the third cell.
> 
> > Also, polarity inversion could still be done in software for hardware
> > that doesn't support it.
> 
> No. You cannot emulate polarity inversion in software.
> 
Why not?

duty_ns = period_ns - duty_ns;


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
