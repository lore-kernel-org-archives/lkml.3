Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaBJJLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:11:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44176 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaBJJLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:11:31 -0500
Date: Mon, 10 Feb 2014 12:11:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, john.stultz@linaro.org, ohaugan@codeaurora.org,
        romlem@google.com, devel@driverdev.osuosl.org, konkers@android.com,
        linux-kernel@vger.kernel.org, ccross@android.com, rebecca@android.com,
        prtvar.b@gmail.com
Subject: Re: [PATCH] staging : android : fix checkpatch issues
Message-ID: <20140210091135.GR26722@mwanda>
References: <2067517.LR5DRBeXLF@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2067517.LR5DRBeXLF@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 10:59:14AM +0900, Daeseok Youn wrote:
> @@ -1376,14 +1376,14 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
>  		}
>  	}
>  	mutex_unlock(&dev->buffer_lock);
> -	seq_printf(s, "----------------------------------------------------\n");
> +	seq_puts(s, "----------------------------------------------------\n");
>  	seq_printf(s, "%16.s %16zu\n", "total orphaned",
>  		   total_orphaned_size);

This kind of thing where you put a seq_puts() in the middle of a string
of seq_printf() calls is not good.  We only make checkpatch.pl warn
about it to see if patch submitters are paying attention and to test the
patience of reviewers.

regards,
dan carpenter

