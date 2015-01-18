Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbbARAdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:33:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbARAdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:33:24 -0500
Date: Sat, 17 Jan 2015 16:22:00 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ION handle already destroyed in ion_free.
Message-ID: <20150118002200.GA8609@kroah.com>
References: <1421476461-18070-1-git-send-email-shailendra.capricorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421476461-18070-1-git-send-email-shailendra.capricorn@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 12:04:21PM +0530, Shailendra Verma wrote:
> 
> Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>
> ---
>  drivers/staging/android/ion/ion.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index 9e56d32..0d2b9a3 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -1279,7 +1279,6 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> 		if (IS_ERR(handle))
> 			return PTR_ERR(handle);
> 		ion_free(client, handle);
> -		ion_handle_put(handle);
> 		break;
> 	}
> 	case ION_IOC_SHARE:
> --
> 1.7.9.5

Are you sure about this?  Did you test it?  How?

thanks,

greg k-h
