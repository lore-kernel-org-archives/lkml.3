Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3FFVtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:49:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43951 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3FFVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:49:32 -0400
Date: Fri, 7 Jun 2013 00:48:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Schilling <of82ecuq@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Kanzenbach <shifty91@gmail.com>, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: Re: [PATCH 4/6] keucr: more readable and friendly error messages
Message-ID: <20130606214838.GG28112@mwanda>
References: <20130605094517.GS28112@mwanda>
 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
 <1370535050-7167-5-git-send-email-of82ecuq@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370535050-7167-5-git-send-email-of82ecuq@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 06:10:48PM +0200, Johannes Schilling wrote:
> @@ -71,7 +71,9 @@ int ENE_SMInit(struct us_data *us)
>  
>  	result = ENE_LoadBinCode(us, SM_INIT_PATTERN);
>  	if (result != USB_STOR_XFER_GOOD) {
> -		dev_info(&us->pusb_dev->dev, "Load SM Init Code Fail !!\n");
> +		dev_info(&us->pusb_dev->dev,
> +			 "Failed to load SmartMedia init code\n: result= %x\n",
> +			 result);

It doens't work to put newlines in the middle of a printk().  It
has to go at the end.  The reason is that dev_xxx() functions add
something to the beginning of lines.

regards,
dan carpenter

