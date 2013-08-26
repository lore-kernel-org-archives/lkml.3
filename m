Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab3HZQGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:06:37 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38010 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab3HZQGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:06:34 -0400
Date: Mon, 26 Aug 2013 19:02:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        harsh1kumar@gmail.com, linux-kernel@vger.kernel.org,
        mujeeb.adil@gmail.com, justinmattock@gmail.com
Subject: Re: [PATCH 05/24] Staging: winbond: phy_calibration: fixed some
 lines over 80 characters
Message-ID: <20130826155627.GB6329@mwanda>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
 <1377529823-5116-6-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377529823-5116-6-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 05:10:04PM +0200, Iker Pedrosa wrote:
> Second of the patches that fixes the lines over 80 characters in phy_calibration.c
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
> ---
>  drivers/staging/winbond/phy_calibration.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
> index 6635c85..a4f3773 100644
> --- a/drivers/staging/winbond/phy_calibration.c
> +++ b/drivers/staging/winbond/phy_calibration.c
> @@ -1233,8 +1233,10 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
>  		b_2 = (rot_image_q_b * 32768) / rot_tone_i_b -
>  			phw_data->iq_rsdl_phase_tx_d2;
>  
> -		PHY_DEBUG(("[CAL]    ** iq_rsdl_gain_tx_d2 = %d\n", phw_data->iq_rsdl_gain_tx_d2));
> -		PHY_DEBUG(("[CAL]    ** iq_rsdl_phase_tx_d2= %d\n", phw_data->iq_rsdl_phase_tx_d2));
> +		PHY_DEBUG(("[CAL]    ** iq_rsdl_gain_tx_d2 = %d\n",
> +				   phw_data->iq_rsdl_gain_tx_d2));

Don't redo this, but really these should be aligned like this:

		PHY_DEBUG(("[CAL]    ** iq_rsdl_gain_tx_d2 = %d\n",
			   phw_data->iq_rsdl_gain_tx_d2));

In the end, we're going to remove all these debugging prints so it's
not worth redoing in a later patch.  What you have is fine.  The
message itself is sort of nonsense.

> +		PHY_DEBUG(("[CAL]    ** iq_rsdl_phase_tx_d2= %d\n",
> +				   phw_data->iq_rsdl_phase_tx_d2));
>  		PHY_DEBUG(("[CAL]    ***** EPSILON/2 = %d\n", a_2));
>  		PHY_DEBUG(("[CAL]    ***** THETA/2   = %d\n", b_2));
>  
> @@ -1280,7 +1282,8 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
>  
>  		/* e. */
>  		pwr_tone = (iqcal_tone_i*iqcal_tone_i + iqcal_tone_q*iqcal_tone_q);
> -		pwr_image = (iqcal_image_i*iqcal_image_i + iqcal_image_q*iqcal_image_q)*factor;
> +		pwr_image = (iqcal_image_i*iqcal_image_i +
> +				   iqcal_image_q*iqcal_image_q)*factor;

Don't resend, eventually, someone will have to fix these across the
whole driver but this should be:

		pwr_image = (iqcal_image_i * iqcal_image_i +
		             iqcal_image_q * iqcal_image_q) * factor;


I've changed the alignment and added spaces around the math
operations.

regards,
dan carpenter

