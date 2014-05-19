Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaESICt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:02:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51558 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaESICq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:02:46 -0400
Date: Mon, 19 May 2014 11:02:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] staging: dgap: implement error handling in
 dgap_tty_register()
Message-ID: <20140519080224.GL16255@mwanda>
References: <20140519021030.GA1051@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519021030.GA1051@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice, but it needs a couple style improvements below.

On Mon, May 19, 2014 at 11:10:30AM +0900, Daeseok Youn wrote:
> +	brd->dgap_major_serial_registered = TRUE;
> +	dgap_boards_by_major[brd->serial_driver->major] = brd;
> +	brd->dgap_serial_major = brd->serial_driver->major;
> +
>  	brd->dgap_major_transparent_print_registered = TRUE;
>  	dgap_boards_by_major[brd->print_driver->major] = brd;
>  	brd->dgap_transparent_print_major = brd->print_driver->major;
>  
>  	return rc;

	return 0;

> +
> +unregister_serial_drv:
> +	tty_unregister_driver(brd->serial_driver);
> +free_print_ttys:
> +	kfree(brd->print_driver->ttys);
> +	brd->print_driver->ttys = NULL;

This label isn't needed.  Just goto free_print_drv, because that will
free the brd->print_driver->ttys in destruct_tty_driver().
I do like how you noticed the double free and avoided it by setting
brd->serial_driver->ttys to NULL, so your patch doesn't introduce a
double free bug.

> +free_print_drv:
> +	put_tty_driver(brd->print_driver);
> +free_serial_ttys:
> +	kfree(brd->serial_driver->ttys);
> +	brd->serial_driver->ttys = NULL;

Same for this.

> +free_serial_drv:
> +	put_tty_driver(brd->serial_driver);
> +
> +	return rc;

regards,
dan carpenter
