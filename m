Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbaJWUX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:23:59 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:52468
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932303AbaJWUX5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:23:57 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: introduce some sample size
 manipulation functions
Thread-Topic: [PATCH] staging: comedi: introduce some sample size
 manipulation functions
Thread-Index: AQHP7r+Y7t3nXuaXn0+dTwoZMt0/VZw+H+fA
Date: Thu, 23 Oct 2014 20:23:49 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FFCBE3@P3PWEX4MB008.ex4.secureserver.net>
References: <1414068471-25575-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1414068471-25575-1-git-send-email-abbotti@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 23, 2014 5:48 AM, Ian Abbott wrote:
> Introduce a few static inline helper functions:
>
> `comedi_bytes_per_sample(s)` is the same as the existing
> `bytes_per_sample(s)` and determines the size of a comedi sample in
> bytes.  (`bytes_per_sample(s)` will be removed.)
>
> `comedi_sample_shift(s)` determines the log2 of the comedi sample size,
> so it can be used in bit-shift operations to multiply or divide by the
> sample size.
>
> `comedi_bytes_to_samples(s, nbytes)` converts a number of bytes to a
> number of samples (rounding down).
>
> `comedi_samples_to_bytes(s, nsamples)` converts a number of samples to a
> number of bytes.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/comedidev.h | 63 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 59 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 1b2bbd5..69cf6fe 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -391,12 +391,67 @@ static inline unsigned int comedi_offset_munge(struct comedi_subdevice *s,
>  	return val ^ s->maxdata ^ (s->maxdata >> 1);
>  }
> 
> -static inline unsigned int bytes_per_sample(const struct comedi_subdevice *subd)
> +/**
> + * comedi_bytes_per_sample - determine subdevice sample size
> + * @s:		comedi_subdevice struct
> + *
> + * The sample size will be 4 (sizeof int) or 2 (sizeof short) depending on
> + * whether the SDF_LSAMPL subdevice flag is set or not.
> + *
> + * Returns the subdevice sample size.
> + */
> +static inline unsigned int comedi_bytes_per_sample(struct comedi_subdevice *s)
>  {
> -	if (subd->subdev_flags & SDF_LSAMPL)
> -		return sizeof(unsigned int);
> +	return s->subdev_flags & SDF_LSAMPL ? sizeof(int) : sizeof(short);

The samples are really 'unsigned' types but I guess it doesn't matter here.

> +}
 
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

