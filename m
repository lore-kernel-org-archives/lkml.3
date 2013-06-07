Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3FGHrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:47:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46103 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751108Ab3FGHre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:47:34 -0400
Message-ID: <1370591253.2209.99.camel@joe-AO722>
Subject: Re: [PATCH] staging: comedi: proc.c Fixed warning and brace code
 style issue [kernel: linux-next:	next-20130607]
From: Joe Perches <joe@perches.com>
To: Daniel Hamacher <danielhamacher.dh@gmail.com>
Cc: greg@kroah.com, abotti@mev.co.uk, fmhess@users.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Jun 2013 00:47:33 -0700
In-Reply-To: <1370590023-5647-1-git-send-email-danielhamacher.dh@gmail.com>
References: <1370590023-5647-1-git-send-email-danielhamacher.dh@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 01:27 -0600, Daniel Hamacher wrote:
> checkpatch provided a warning on line 38. It recommended seq_puts instead of seq_printf.
> Since the return value of printf is ignored, I decided to switch to the seq_puts
> function since it is just regular character output.
> source:: http://lwn.net/Articles/22355/
> 
> I also added braces on a for loop, since loops should be in braces.
> source:: Documentation/CodingStyle
> 
> Signed-off-by: Daniel Hamcher <danielhamacher.dh@gmail.com>
> ---
>  drivers/staging/comedi/proc.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/comedi/proc.c b/drivers/staging/comedi/proc.c
> index 8ee9442..5cf19b3 100644
> --- a/drivers/staging/comedi/proc.c
> +++ b/drivers/staging/comedi/proc.c
> @@ -34,11 +34,11 @@ static int comedi_read(struct seq_file *m, void *v)
>  	int devices_q = 0;
>  	struct comedi_driver *driv;
>  
> -	seq_printf(m,
> -		     "comedi version " COMEDI_RELEASE "\n"
> -		     "format string: %s\n",
> -		     "\"%2d: %-20s %-20s %4d\", i, "
> -		     "driver_name, board_name, n_subdevices");
> +	seq_puts(m,
> +		"comedi version " COMEDI_RELEASE "\n"
> +		"format string: %s\n",
> +		"\"%2d: %-20s %-20s %4d\", i, "
> +		"driver_name, board_name, n_subdevices");

Please compile the files patched by your patches
before submitting the patches.

This doesn't compile, the seq_printf is correct
and the recommendation to use seq_puts not correct.
checkpatch ain't perfect.

> @@ -57,10 +57,11 @@ static int comedi_read(struct seq_file *m, void *v)
>  
>  	for (driv = comedi_drivers; driv; driv = driv->next) {
>  		seq_printf(m, "%s:\n", driv->driver_name);
> -		for (i = 0; i < driv->num_names; i++)
> +		for (i = 0; i < driv->num_names; i++) {
>  			seq_printf(m, " %s\n",
>  				   *(char **)((char *)driv->board_name +
>  					      i * driv->offset));
> +		}

Adding braces here is not necessary.

Run checkpatch on your patches too.


