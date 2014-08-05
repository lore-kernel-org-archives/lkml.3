Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaHEXfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:35:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaHEXfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:35:08 -0400
Date: Tue, 5 Aug 2014 16:35:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dzonatans Melgalvis <dz.melgalvis@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: comedidev.h: fix checkpatch code style
 issue
Message-ID: <20140805233507.GA27293@kroah.com>
References: <1407281385-12576-1-git-send-email-dz.melgalvis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407281385-12576-1-git-send-email-dz.melgalvis@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 02:29:45AM +0300, Dzonatans Melgalvis wrote:
> Fixing checkpatch warning - blank line missing after declaration.
> 
> Signed-off-by: Dzonatans Melgalvis <dz.melgalvis@gmail.com>
> ---
>  drivers/staging/comedi/comedidev.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 58e58a3..c9b7978 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -57,6 +57,7 @@ struct comedi_subdevice {
>  	const unsigned int *maxdata_list;	/* list is channel specific */
>  
>  	const struct comedi_lrange *range_table;
> +
>  	const struct comedi_lrange *const *range_table_list;

Really?  Why add that one?  Shouldn't you just remove the previous line?

>  
>  	unsigned int *chanlist;	/* driver-owned chanlist (not used) */
> @@ -207,8 +208,10 @@ struct comedi_async {
>  	struct comedi_cmd cmd;
>  	wait_queue_head_t wait_head;
>  	unsigned int cb_mask;
> +
>  	int (*inttrig)(struct comedi_device *dev, struct comedi_subdevice *s,
>  		       unsigned int x);
> +
>  };

Why is that last line needed?

Please use your judgement with checkpatch fixes, this patch isn't ok
as-is, sorry.

greg k-h
