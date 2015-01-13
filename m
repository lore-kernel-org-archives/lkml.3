Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbbAMVVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:21:24 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34914 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbbAMVVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:21:21 -0500
From: bill <bilel.dr@gmail.com>
X-Google-Original-From: bill <bill@bill-Lenovo-IdeaPad-Z510>
Date: Tue, 13 Jan 2015 22:21:16 +0100
To: Joe Perches <joe@perches.com>
Cc: Bilel DRIRA <bilel.dr@gmail.com>, marek.belisko@gmail.com,
        gregkh@linuxfoundation.org, tapaswenipathak@gmail.com,
        gdonald@gmail.com, aybuke.147@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ft1000: fix else style error
Message-ID: <20150113212116.GA8436@bill-Lenovo-IdeaPad-Z510>
References: <ft1000else_style>
 <1421150221-16028-1-git-send-email-bilel.dr@gmail.com>
 <1421164899.9233.21.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421164899.9233.21.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 08:01:39AM -0800, Joe Perches wrote:
> On Tue, 2015-01-13 at 12:57 +0100, Bilel DRIRA wrote:
> > 	ERROR: else should follow close brace '}'
> []
> > diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> []
> > @@ -572,8 +572,7 @@ static void ft1000_hbchk(u_long data)
> >  		if (tempword != ho) {
> >  			if (info->AsicID == ELECTRABUZZ_ID) {
> >  				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
> > -			}
> > -			else {
> > +			} else {
> >  				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
> >  			}
> >  		}
> 
> True, but you could instead remove all the braces
> around both arms from all uses of
> 
> 	if (test) {
> 		<single statement>;
> 	} else {
> 		<single statement>;
> 	}
> 
> > @@ -688,15 +687,13 @@ static void ft1000_hbchk(u_long data)
> >  		if (tempword != hi) {
> >  			if (info->AsicID == ELECTRABUZZ_ID) {
> >  				ft1000_write_dpram(dev, FT1000_HI_HO, hi);
> > -			}
> > -			else {
> > +			} else {
> >  				ft1000_write_dpram_mag_16(dev, FT1000_MAG_HI_HO, hi_mag, FT1000_MAG_HI_HO_INDX);
> >  			}
> 
> etc...
> 
> 

Hi Joe,

Of course, you are right. I will do that and resend the patch.

Thanks.
