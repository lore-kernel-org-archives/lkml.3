Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaB1Jmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:42:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30295 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaB1Jmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:42:40 -0500
Date: Fri, 28 Feb 2014 12:42:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] Staging: comedi: fix lines that are over 80
 characters
Message-ID: <20140228094215.GJ26776@mwanda>
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
 <1393578945-20488-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393578945-20488-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 03:15:45AM -0600, Chase Southwood wrote:
> This patch introduces a simple helper function, outl_1564_timer(), to
> allow several lines which violate the character limit to be shortened.
> A handful of other lines that are too long are appropriately split as
> well.
> 
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 2: introduced outl_1564_timer() at the suggestion of Dan.
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 83 +++++++++++++---------
>  1 file changed, 49 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> index 2b47fa1..d958d3c 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> @@ -99,6 +99,9 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
>  #define APCI1564_TCW_WARN_TIMEVAL			24
>  #define APCI1564_TCW_WARN_TIMEBASE			28
>  
> +/* Helper functions */

Obvious comment is too obvious.

> +static void outl_1564_timer(struct addi_private *, unsigned int, unsigned int);
> +

Avoid forward declarations.  Put the function itself here.

Do a function for APCI1564_DIGITAL_IP as well.

outl_1564_digital_ip()
inl_1564_digital_ip()

To be honest, I'm not sure how much the 1564 adds to the name.  The
names should match of course.

I wonder if this line is buggy?:
outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE1); /* Disable the and/or interrupt */
Should it be?
outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP + APCI1564_DIGITAL_IP_INTERRUPT_MODE1);

You would need to read the specs to be sure.

Anyway, take some more time with this and play with different ways to
clean it up.

regards,
dan carpenter

