Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3FFVqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:46:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50862 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3FFVqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:46:03 -0400
Date: Fri, 7 Jun 2013 00:44:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Schilling <of82ecuq@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Kanzenbach <shifty91@gmail.com>, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: Re: [PATCH 6/6] keucr: fix some alignment- and whitespace-problems
Message-ID: <20130606214442.GF28112@mwanda>
References: <20130605094517.GS28112@mwanda>
 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
 <1370535050-7167-7-git-send-email-of82ecuq@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370535050-7167-7-git-send-email-of82ecuq@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 06:10:50PM +0200, Johannes Schilling wrote:
> resolves checkpatch errors and warnings regarding whitespace around
> operators, line lengths and indentation.
> 

I feel like this should be broken up into several patches.  A lot of
these changes will make checkpatch.pl happy but they are not
beautiful.

> --- a/drivers/staging/keucr/init.c
> +++ b/drivers/staging/keucr/init.c
> @@ -98,11 +98,16 @@ int ENE_SMInit(struct us_data *us)
>  	us->SM_CardID   = buf[2];
>  
>  	if (us->SM_Status.Insert && us->SM_Status.Ready) {

The better way to solve this is:

-		dev_info(&us->pusb_dev->dev, "Insert     = %x\n", us->SM_Status.Insert);
+		dev_info(us_dev, "Insert     = %x\n", us->SM_Status.Insert);

> -		dev_info(&us->pusb_dev->dev, "Ready      = %x\n", us->SM_Status.Ready);
> -		dev_info(&us->pusb_dev->dev, "WtP        = %x\n", us->SM_Status.WtP);
> -		dev_info(&us->pusb_dev->dev, "DeviceID   = %x\n", us->SM_DeviceID);
> -		dev_info(&us->pusb_dev->dev, "CardID     = %x\n", us->SM_CardID);
> +		dev_info(&us->pusb_dev->dev, "Insert     = %x\n",
> +					     us->SM_Status.Insert);
> +		dev_info(&us->pusb_dev->dev, "Ready      = %x\n",
> +					     us->SM_Status.Ready);
> +		dev_info(&us->pusb_dev->dev, "WtP        = %x\n",
> +					     us->SM_Status.WtP);
> +		dev_info(&us->pusb_dev->dev, "DeviceID   = %x\n",
> +					     us->SM_DeviceID);
> +		dev_info(&us->pusb_dev->dev, "CardID     = %x\n",
> +					     us->SM_CardID);
>  		MediaChange = 1;
>  		Check_D_MediaFmt(us);
>  	} else {
> @@ -174,7 +179,8 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
>  	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
>  					    bcb, US_BULK_CB_WRAP_LEN, NULL);
>  	if (result != USB_STOR_XFER_GOOD) {
> -		dev_err(&us->pusb_dev->dev, "send cmd to out endpoint fail ---\n");
> +		dev_err(&us->pusb_dev->dev,
> +				"send cmd to out endpoint fail ---\n");

Line the parameters up:

+		dev_info(&us->pusb_dev->dev,
+			 "my extra long messssssssssssssssagesfasdfadf ---\n");

I used 3 tabs and a space to make everything line up correctly.  But
if you use a temporary variable this will fit on one line.


> @@ -604,9 +604,9 @@ static int eucr_probe(struct usb_interface *intf,
>  	if (!(MiscReg03 & 0x02)) {
>  		result = -ENODEV;
>  		quiesce_and_remove_host(us);
> -		pr_info("keucr: The driver only supports SM/MS card.\
> -			To use SD card, \
> -			please build driver/usb/storage/ums-eneub6250.ko\n");
> +		pr_info("keucr: The driver only supports SM/MS card. "
> +			"To use SD card, "
> +			"please build driver/usb/storage/ums-eneub6250.ko\n");
>  		goto BadDevice;
>  	}
>  

This is a bug fix.  It should go in as a separate patch.

regards,
dan carpenter
