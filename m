Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaEDBDM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:03:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaEDBDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:03:11 -0400
Date: Sat, 3 May 2014 19:58:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: fix sparse warning: shift too big
Message-ID: <20140503235838.GA20243@kroah.com>
References: <1399042624-9441-1-git-send-email-brilliantov@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399042624-9441-1-git-send-email-brilliantov@inbox.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 06:57:04PM +0400, Brilliantov Kirill Vladimirovich wrote:
> Signed-off-by: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
> ---
>  drivers/staging/comedi/drivers/ni_stc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
> index f0630b78..197b568 100644
> --- a/drivers/staging/comedi/drivers/ni_stc.h
> +++ b/drivers/staging/comedi/drivers/ni_stc.h
> @@ -717,7 +717,7 @@ enum AI_AO_Select_Bits {
>  static inline unsigned ni_stc_dma_channel_select_bitfield(unsigned channel)
>  {
>  	if (channel < 4)
> -		return 1 << channel;
> +		return 1 << (channel & 0x3);

That change does nothing, so it's not worth applying, don't you agree?

thanks,

greg k-h
