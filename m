Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbbAVKZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:25:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47937 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbbAVKZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:25:00 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 05:24:59 EST
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 22 Jan 2015 11:16:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: ohci:  Remove unused function
Message-ID: <20150122111626.463882b2@kant>
In-Reply-To: <1420232563-3464-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420232563-3464-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 02 Rickard Strandqvist wrote:
> Remove the function ar_prev_buffer_index() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Committed to linux1394.git, thanks.  (The function was used in an earlier
version of patch "firewire: ohci: AR rewrite" which later became commit
7a39d8b82165.  In a revision of the patch, the use but not the definition
of this function was removed.)

> ---
>  drivers/firewire/ohci.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
> index a66a321..9662daa 100644
> --- a/drivers/firewire/ohci.c
> +++ b/drivers/firewire/ohci.c
> @@ -719,11 +719,6 @@ static inline unsigned int ar_next_buffer_index(unsigned int index)
>  	return (index + 1) % AR_BUFFERS;
>  }
>  
> -static inline unsigned int ar_prev_buffer_index(unsigned int index)
> -{
> -	return (index - 1 + AR_BUFFERS) % AR_BUFFERS;
> -}
> -
>  static inline unsigned int ar_first_buffer_index(struct ar_context *ctx)
>  {
>  	return ar_next_buffer_index(ctx->last_buffer_index);

-- 
Stefan Richter
-=====-===== ---= =-==-
http://arcgraph.de/sr/
