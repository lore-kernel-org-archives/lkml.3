Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3L0WGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:06:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56870 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab3L0WGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:06:43 -0500
Message-ID: <52BDF9EA.7050400@zytor.com>
Date: Fri, 27 Dec 2013 14:06:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] Use __kernel_long_t in struct timex
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com> <1388165112-6545-2-git-send-email-hjl.tools@gmail.com>
In-Reply-To: <1388165112-6545-2-git-send-email-hjl.tools@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2013 09:25 AM, H.J. Lu wrote:
> X32 adjtimex system call is the same as x86-64 adjtimex system call,
> which uses 64-bit integer for long in struct timex. But x32 long is
> 32 bit.  This patch replaces long in struct timex with __kernel_long_t
> if __BITS_PER_LONG == 64.
> 
> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> ---
>  include/uapi/linux/timex.h | 46 ++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/include/uapi/linux/timex.h b/include/uapi/linux/timex.h
> index a7ea81f..98314e9 100644
> --- a/include/uapi/linux/timex.h
> +++ b/include/uapi/linux/timex.h
> @@ -63,28 +63,58 @@
>   */
>  struct timex {
>  	unsigned int modes;	/* mode selector */
> +#if __BITS_PER_LONG == 64
> +	__kernel_long_t offset;	/* time offset (usec) */
> +	__kernel_long_t freq;	/* frequency offset (scaled ppm) */
> +	__kernel_long_t maxerror;/* maximum error (usec) */
> +	__kernel_long_t esterror;/* estimated error (usec) */
> +#else
>  	long offset;		/* time offset (usec) */
>  	long freq;		/* frequency offset (scaled ppm) */
>  	long maxerror;		/* maximum error (usec) */
>  	long esterror;		/* estimated error (usec) */
> +#endif
>  	int status;		/* clock command/status */

I thought we already discussed this?  No __BITS_PER_LONG conditionals,
please, unless you can strongly motivate them... and if so, we probably
should introduce another __kernel type instead.

	-hpa


