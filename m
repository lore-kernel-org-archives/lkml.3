Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3HZQuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:50:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48389 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756994Ab3HZQuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:50:24 -0400
Message-ID: <1377535823.1782.46.camel@joe-AO722>
Subject: Re: [PATCH 05/24] Staging: winbond: phy_calibration: fixed some
 lines over 80 characters
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Iker Pedrosa <ikerpedrosam@gmail.com>, pavel@ucw.cz,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        harsh1kumar@gmail.com, linux-kernel@vger.kernel.org,
        mujeeb.adil@gmail.com, justinmattock@gmail.com
Date: Mon, 26 Aug 2013 09:50:23 -0700
In-Reply-To: <20130826155627.GB6329@mwanda>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
	 <1377529823-5116-6-git-send-email-ikerpedrosam@gmail.com>
	 <20130826155627.GB6329@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-26 at 19:02 +0300, Dan Carpenter wrote:
> On Mon, Aug 26, 2013 at 05:10:04PM +0200, Iker Pedrosa wrote:
[]
> > diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
[]
> > @@ -1233,8 +1233,10 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
> >  		b_2 = (rot_image_q_b * 32768) / rot_tone_i_b -
> >  			phw_data->iq_rsdl_phase_tx_d2;
> >  
> > -		PHY_DEBUG(("[CAL]    ** iq_rsdl_gain_tx_d2 = %d\n", phw_data->iq_rsdl_gain_tx_d2));
> > -		PHY_DEBUG(("[CAL]    ** iq_rsdl_phase_tx_d2= %d\n", phw_data->iq_rsdl_phase_tx_d2));
> > +		PHY_DEBUG(("[CAL]    ** iq_rsdl_gain_tx_d2 = %d\n",
> > +				   phw_data->iq_rsdl_gain_tx_d2));
> 
> Don't redo this, but really these should be aligned like this:
> 
> 		PHY_DEBUG(("[CAL]    ** iq_rsdl_gain_tx_d2 = %d\n",
> 			   phw_data->iq_rsdl_gain_tx_d2));
> 
> In the end, we're going to remove all these debugging prints so it's
> not worth redoing in a later patch.  What you have is fine.  The
> message itself is sort of nonsense.

Especially true because the only #define for PHY_DEBUG is:

#define PHY_DEBUG(msg, args...)

None of this does anything anyway.

It'd be better to send a removal of the whole lot.

Does anyone still use this driver?


