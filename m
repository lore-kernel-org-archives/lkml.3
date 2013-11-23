Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab3KWRWj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 12:22:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3KWRWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 12:22:38 -0500
Date: Sat, 23 Nov 2013 09:23:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Abhishek Sudhakaran <itzurabhi@gmail.com>
Cc: abbotti@mev.co.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:comedi:pcmmio Fixed a printk format in debug
 section
Message-ID: <20131123172315.GB8405@kroah.com>
References: <1385206533-3289-1-git-send-email-itzurabhi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385206533-3289-1-git-send-email-itzurabhi@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 05:05:32PM +0530, Abhishek Sudhakaran wrote:
> Fixed a printk statement in the debug section
> where the string terminator was misplaced.
> 
> Signed-off-by: Abhishek Sudhakaran <itzurabhi@gmail.com>
> ---
>  drivers/staging/comedi/drivers/pcmmio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
> index 14cee3a..bc1f44c 100644
> --- a/drivers/staging/comedi/drivers/pcmmio.c
> +++ b/drivers/staging/comedi/drivers/pcmmio.c
> @@ -274,7 +274,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
>  #ifdef DAMMIT_ITS_BROKEN
>  		/* DEBUG */
>  		printk
> -		    (KERN_DEBUG "byte %d wmb %02x db %02x offset %02d io %04x,"
> +		    (KERN_DEBUG "byte %d wmb %02x db %02x offset %02d io %04x",
>  		     " data_in %02x ", byte_no, (unsigned)write_mask_byte,
>  		     (unsigned)data_byte, offset, ioaddr, (unsigned)byte);

Did you build this patch?  I think the original code is correct, and
your change will cause an error, right?

greg k-h
