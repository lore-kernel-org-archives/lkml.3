Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaLUHMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 02:12:20 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51995 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaLUHMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 02:12:17 -0500
Date: Sat, 20 Dec 2014 23:12:13 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Sage Vaillancourt <sagev9000@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, chase.southwood@gmail.com,
        ebru.akagunduz@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix spacing issues in ni_stc.h
Message-ID: <20141221071213.GA10123@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Sage Vaillancourt <sagev9000@gmail.com>, abbotti@mev.co.uk,
	hsweeten@visionengravers.com, gregkh@linuxfoundation.org,
	chase.southwood@gmail.com, ebru.akagunduz@gmail.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1419127314-5743-1-git-send-email-sagev9000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419127314-5743-1-git-send-email-sagev9000@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage,

On Sat, Dec 20, 2014 at 09:01:54PM -0500, Sage Vaillancourt wrote:
> Patch to the ni_stc.h file that removes spaces before tabs, and adds blank lines
> 	after declarations.
> Signed-off-by: Sage Vaillancourt <sagev9000@gmail.com>

Format your log message so it is no more than 80 characters wide (I like
72) and remove the gratuitous spacing on the second line.

Put a blank line between your log message and your Signed-off-by:

This patch is doing two things: adding blank lines and fixing
spaces/tabs in a line.  Break it up in to two patches.

> ---
>  drivers/staging/comedi/drivers/ni_stc.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
> index bd69c3f..3b8b3c5 100644
> --- a/drivers/staging/comedi/drivers/ni_stc.h
> +++ b/drivers/staging/comedi/drivers/ni_stc.h
> @@ -166,7 +166,7 @@ enum Interrupt_B_Ack_Bits {
>  #define AI_SCAN_IN_PROG_Pulse			_bit4
>  #define AI_EXTMUX_CLK_Pulse			_bit3
>  #define AI_LOCALMUX_CLK_Pulse			_bit2
> -#define AI_SC_TC_Pulse			 	_bit1
> +#define AI_SC_TC_Pulse				_bit1
>  #define AI_CONVERT_Pulse			_bit0
>  
>  #define AO_Command_1_Register		9
> @@ -326,6 +326,7 @@ static inline unsigned RTSI_Output_Bit(unsigned channel, int is_mseries)
>  {
>  	unsigned max_channel;
>  	unsigned base_bit_shift;
> +
>  	if (is_mseries) {
>  		base_bit_shift = 8;
>  		max_channel = 7;
> @@ -642,7 +643,7 @@ static unsigned AO_UPDATE_Output_Select(enum ao_update_output_selection
>  #define G_Load_Source_Select		_bit7
>  #define G_Reload_Source_Switching	_bit15
>  #define G_Loading_On_Gate		_bit14
> -#define G_Gate_Polarity 		_bit13
> +#define G_Gate_Polarity			_bit13
>  
>  #define G_Counting_Once(a)		(((a)&0x03)<<10)
>  #define G_Stop_Mode(a)			(((a)&0x03)<<5)
> @@ -1142,6 +1143,7 @@ static inline unsigned MSeries_AI_Config_Bank_Bits(enum ni_reg_type reg_type,
>  						   unsigned channel)
>  {
>  	unsigned bits = channel & 0x30;
> +
>  	if (reg_type == ni_reg_622x) {
>  		if (channel & 0x40)
>  			bits |= 0x400;
> @@ -1191,6 +1193,7 @@ enum MSeries_PLL_Control_Bits {
>  static inline unsigned MSeries_PLL_Divisor_Bits(unsigned divisor)
>  {
>  	static const unsigned max_divisor = 0x10;
> +
>  	if (divisor < 1 || divisor > max_divisor) {
>  		pr_err("%s: bug, invalid divisor=%i\n", __func__, divisor);
>  		return 0;
> @@ -1201,6 +1204,7 @@ static inline unsigned MSeries_PLL_Divisor_Bits(unsigned divisor)
>  static inline unsigned MSeries_PLL_Multiplier_Bits(unsigned multiplier)
>  {
>  	static const unsigned max_multiplier = 0x100;
> +
>  	if (multiplier < 1 || multiplier > max_multiplier) {
>  		pr_err("%s: bug, invalid multiplier=%i\n", __func__,
>  		       multiplier);
> -- 
> 2.2.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
