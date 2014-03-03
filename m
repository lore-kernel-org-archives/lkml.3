Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaCCJ2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:28:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47781 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaCCJ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:28:16 -0500
Date: Mon, 3 Mar 2014 12:27:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Staging: comedi: introduce {outl,inl}_amcc() and
 {outl,inl}_iobase() helper functions in hwdrv_apci1564.c
Message-ID: <20140303092755.GD27552@mwanda>
References: <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com>
 <1393815139-10663-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393815139-10663-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 08:52:19PM -0600, Chase Southwood wrote:
> This patch introduces a few simple outl and inl helper functions to allow
> several lines which violate the character limit to be shortened
> appropriately.  It also changes a few macro values which represented
> offset values from a single unique base value to instead represent the value
> of that base plus the offset.  This is to simplify the use of these macros
> in the new helper functions.
> 
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 
> All right, here's another shot at this.  Dan, I took your outl_amcc idea
> and did a version for the outl/inl calls based from devpriv->iobase as well.
> I changed all of the macros which only offset from one base value as you
> had mentioned as well, and the result is starting to look very good.
> The only outl/inl calls which still look a little gross (see PATCH v2 2/2) are
> the ones involving DIGITAL_OP_WATCHDOG, TIMER, or any of the COUNTER macros,
> just because they use a common set of offset macros so simplifying
> those calls in the same way as the rest isn't possible.  What are your
> thoughts on this version of the patchset?
> 
> This is version 2 of [PATCH 1/2] Staging: comedi: introduce outl_1564_* and
> inl_1564_* helper functions in hwdrv_apci1564.c
> 
> 2: Changed helper functions from {outl,inl}_1564_*() to
> {outl,inl}_{amcc,iobase}()
> 
> Comments welcome!
> 
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 38 +++++++++++++++++-----
>  1 file changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> index 2b47fa1..58e301d 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> @@ -49,25 +49,25 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
>  /* DIGITAL INPUT-OUTPUT DEFINE */
>  /* Input defines */
>  #define APCI1564_DIGITAL_IP				0x04
> -#define APCI1564_DIGITAL_IP_INTERRUPT_MODE1		4
> -#define APCI1564_DIGITAL_IP_INTERRUPT_MODE2		8
> -#define APCI1564_DIGITAL_IP_IRQ				16
> +#define APCI1564_DIGITAL_IP_INTERRUPT_MODE1		(0x04 + 0x04)
> +#define APCI1564_DIGITAL_IP_INTERRUPT_MODE2		(0x04 + 0x08)
> +#define APCI1564_DIGITAL_IP_IRQ				(0x04 + 0x10)

You can't change these without changing the callers.  This bit needs to
be in patch 2/2.  You should probably just merge both patches anyway
because presumably this one adds some GCC warnings about unused static
functions.

regards,
dan carpenter


