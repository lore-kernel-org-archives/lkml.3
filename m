Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbbA2B5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:57:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbbA2B5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:57:20 -0500
Date: Wed, 28 Jan 2015 10:51:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Heba Aamer <heba93aamer@gmail.com>
Cc: devel@driverdev.osuosl.org, dmitry.eremin@intel.com, tristan@lelong.xyz,
        andreas.dilger@intel.com, brilliantov@inbox.ru,
        linux-kernel@vger.kernel.org, oleg.drokin@intel.com, gdonald@gmail.com,
        HPDD-discuss@ml01.01.org
Subject: Re: [PATCH] staging: lustre: lustre: osc: fix Prefer seq_puts to
 seq_printf
Message-ID: <20150128185155.GA6417@kroah.com>
References: <20150128140533.GA14301@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128140533.GA14301@mohammed-Inspiron-3537>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 04:05:33PM +0200, Heba Aamer wrote:
> This patch fixes the following checkpatch.pl warning:
> Prefer seq_puts to seq_printf
> 
> Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
> ---
>  drivers/staging/lustre/lustre/osc/lproc_osc.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
> index 8e22e45..4da837e 100644
> --- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
> +++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
> @@ -364,7 +364,7 @@ static int osc_checksum_type_seq_show(struct seq_file *m, void *v)
>  		else
>  			seq_printf(m, "%s ", cksum_name[i]);
>  	}
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");

I don't think this is a straight search/replace issue, but:

>  	return 0;
>  }
>  
> @@ -601,7 +601,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
>  	seq_printf(seq, "pending read pages:   %d\n",
>  		   atomic_read(&cli->cl_pending_r_pages));
>  
> -	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
> +	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
>  	seq_printf(seq, "pages per rpc	 rpcs   %% cum %% |");
>  	seq_printf(seq, "       rpcs   %% cum %%\n");

if it were, why didn't you fix the other uses here?

thanks,

greg k-h
