Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaCCJkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:40:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18112 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaCCJky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:40:54 -0500
Date: Mon, 3 Mar 2014 12:40:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, abbotti@mev.co.uk
Subject: Re: [PATCH v2 2/2] Staging: comedi: use inl() and outl() helper
 functions
Message-ID: <20140303094034.GL26722@mwanda>
References: <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com>
 <1393815153-10708-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393815153-10708-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 08:52:33PM -0600, Chase Southwood wrote:
> Use the newly created helper functions to improve code readability and shorten
> several lines to under the character limit.
> 
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 
> I've reviewed this as best as I can, but I know it's a bear to review.
> If there is some logical way that you'd like me to split this up into separate
> patches to make it easier to review, please let me know.
> 
> Also, Dan, as best as I can possibly tell, i_APCI1564_Reset() is absolutely
> buggy.  When making up this patch, I made the changes that seem correct (and
> somewhat obvious) from looking at the other addi-data drivers, the other
> functions in this file, and the hardware specs that I could find, but
> unfortunately I have no way to test the code.

You need to put this into the commit message...  You can't change how
the code works without at least mentioning it in the commit.

It would be easier to review these patches if you introduced the helpers
first and switched everything to use them.  Then in 2/2 you changed the
defines to the combined versions.

> @@ -333,81 +313,61 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
>  		devpriv->b_TimerSelectMode = ADDIDATA_WATCHDOG;
>  
>  		/* Disable the watchdog */
> -		outl(0x0,
> -			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
> -			APCI1564_TCW_PROG);
> +		outl_amcc(devpriv, 0x0,
> +				  APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_PROG);


This isn't indented correctly.  It should be:

		outl_amcc(devpriv, 0x0,
			  APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_PROG);

[tab][tab][tab][space][space]APCI1564_DIGITAL_OP_WATCHDOG...

The same thing in a couple other places as well.

regards,
dan carpenter

