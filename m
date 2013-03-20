Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225Ab3CTMsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:48:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39922 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933916Ab3CTMsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:48:07 -0400
Date: Wed, 20 Mar 2013 15:47:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alice Ferrazzi <alice.ferrazzi@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: serial2002: fixed consistent spacing
 issue
Message-ID: <20130320124753.GZ9138@mwanda>
References: <1363782411-11729-1-git-send-email-alice.ferrazzi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363782411-11729-1-git-send-email-alice.ferrazzi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 09:26:51PM +0900, Alice Ferrazzi wrote:
> Fixed consistent spacing around '*'.
> 

The original was correct, actually.

> Signed-off-by: Alice Ferrazzi <alice.ferrazzi@gmail.com>
> ---
>  drivers/staging/comedi/drivers/serial2002.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
> index e6177b4..858d364 100644
> --- a/drivers/staging/comedi/drivers/serial2002.c
> +++ b/drivers/staging/comedi/drivers/serial2002.c
> @@ -604,7 +604,7 @@ static int serial_2002_open(struct comedi_device *dev)
>  							    c[j].max;
>  							range_table_list[chan] =
>  							    (const struct
> -							     comedi_lrange *)
> +							     comedi_lrange*)
>  							    &range[j];

The original code here needs to broken up into functions so it isn't
squashed up against the 80 character limit.

For casts the spacing should look like:

	foo = (struct my_struct *)ptr;

There is a space after "my_struct" but no space after the closing
parenthesis.  Use that to remind yourself that casting is a high
precedence operation.

For declaring pointers the spacing is:

	struct my_struct *ptr;

For multiplication the spacing is:

	foo = x * y;

Or multplication with a dereference it would be:

	foo = x * *ptr;


regards,
dan carpenter

