Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaG3AeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:34:04 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:48267
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459AbaG3AeD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:34:03 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 13/19] staging: comedi: amplc_pci230: remove unnecessary
 braces
Thread-Topic: [PATCH 13/19] staging: comedi: amplc_pci230: remove
 unnecessary braces
Thread-Index: AQHPqySDWqNf214aDEKhZQHeSSh5Tpu3w00Q
Date: Wed, 30 Jul 2014 00:34:01 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F28DA8@P3PWEX4MB008.ex4.secureserver.net>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
 <1406635107-27950-14-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1406635107-27950-14-git-send-email-abbotti@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 29, 2014 4:58 AM,  Ian Abbott wrote:
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/drivers/amplc_pci230.c | 151 ++++++++++----------------
>  1 file changed, 58 insertions(+), 93 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
> index 4222e28..df58679 100644
> --- a/drivers/staging/comedi/drivers/amplc_pci230.c
> +++ b/drivers/staging/comedi/drivers/amplc_pci230.c
> @@ -672,7 +672,7 @@ static int get_resources(struct comedi_device *dev, unsigned int res_mask,
>  	ok = 1;
>  	claimed = 0;
>  	spin_lock_irqsave(&devpriv->res_spinlock, irqflags);
> -	for (b = 1, i = 0; (i < NUM_RESOURCES) && res_mask; b <<= 1, i++) {
> +	for (b = 1, i = 0; (i < NUM_RESOURCES) && res_mask; b <<= 1, i++)
>  		if (res_mask & b) {
>  			res_mask &= ~b;
>  			if (devpriv->res_owner[i] == OWNER_NONE) {
> @@ -690,7 +690,6 @@ static int get_resources(struct comedi_device *dev, unsigned int res_mask,
>  				break;
>  			}
>  		}
> -	}

Technically the braces you remove in this patch _are_
unnecessary. But, I think the driver is more confusing
with them removed.

In a lot of places there is quite a bit of code between
where the opening and closing braces would be.
Granted, a lot of them are due to the wordy comments
but some are in places like:

	for (...)
		if (...) {
			...
		}

There aren't too bad but the one like this are:

	If (...)
		If (...)
			...
		else
			...
	else
		...

The nested if/else blocks are easy to break.

Just my two cents...
Hartley

