Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbbALTvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:51:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbbALTvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:51:13 -0500
Date: Mon, 12 Jan 2015 11:51:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sam van Kampen <sam@tehsvk.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Chris Bajumpaa <cbajumpa@gmail.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org
Subject: Re: [PATCH] Staging: line6: fix parentheses around macro in usbdefs.h
Message-ID: <20150112195111.GA10572@kroah.com>
References: <20141203183442.GA3480@nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203183442.GA3480@nsa.gov>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 07:34:42PM +0100, Sam van Kampen wrote:
> This patch fixes the error "Macros with complex values should be enclosed in
> parentheses", as reported by checkpatch.pl.
> 
> Signed-off-by: Sam van Kampen <sam@tehsvk.net>
> ---
>  drivers/staging/line6/usbdefs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
> index 2d1cc47..48958b5 100644
> --- a/drivers/staging/line6/usbdefs.h
> +++ b/drivers/staging/line6/usbdefs.h
> @@ -40,7 +40,7 @@
>  #define LINE6_DEVID_TONEPORT_UX2  0x4142
>  #define LINE6_DEVID_VARIAX        0x534d
>  
> -#define LINE6_BIT(x) LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x
> +#define LINE6_BIT(x) (LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x)
>  
>  enum {
>  	LINE6_INDEX_BASSPODXT,

I love this line in the driver, it proves that people make changes to
the code without even building it.

Please ALWAYS test-build your patches, otherwise you waste people's time
and make them grumpy.

greg k-h
