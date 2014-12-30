Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaL3SF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 13:05:56 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62848 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaL3SFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 13:05:54 -0500
Date: Tue, 30 Dec 2014 19:05:49 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Laurent Georget <laurent.georget@supelec.fr>
Cc: linux-man <linux-man@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adjtimex.2: Add details about ADJ_FREQUENCY
Message-ID: <20141230180549.GB7403@localhost.localdomain>
References: <54A2DEAD.2050708@supelec.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A2DEAD.2050708@supelec.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 06:19:41PM +0100, Laurent Georget wrote:
> Hi,
> 
> this is another patch for adjtimex(2) man page which fixes a FIXME by
> giving the scaling unit of timex.freq and adds a detail about the value
> expected by ADJ_FREQUENCY.
> 
> Laurent
> 
> diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
> index 18823c8..2652fc6 100644
> --- a/man2/adjtimex.2
> +++ b/man2/adjtimex.2
> @@ -55,8 +55,8 @@ struct timex {
>                           status flag is set, otherwise
>                           microseconds */
>      long freq;        /* Frequency offset, as scaled PPM
> -                         (parts per million) */
> -.\" FIXME What is the scaling unit of timex.freq?  2^16 ?

Your text sounds funny and seems unclear to me.  How about something
more like this:

	long freq	/* Frequency offset in PPM with a 16 bit
			   factional field */

> +                         (parts per million) :
> +                         the scaling unit of timex.freq is 2^16 usec =
> 1000*2^16 nsec.

Your mailer is wrapping lines here ...

>      long maxerror;    /* Maximum error (microseconds) */
>      long esterror;    /* Estimated error (microseconds) */
>      int  status;      /* Clock command/status */
> @@ -106,6 +106,10 @@ Set time offset from
>  .BR ADJ_FREQUENCY
>  Set frequency offset from
>  .IR buf.freq .
> +The clock frequency must be comprised between -500000 and 500000 scaled
> ns/s.

and here.

The phrase "must be comprised" does not make any sense in this
context. How about this instead?

   The allowed frequency range is -500 PPM to +500 PPM.

> +If the given value is outside those bounds, it is silently truncated. This
> +corresponds to values between -32768000 and 32768000 for
> +.IR buf.freq .
>  .TP
>  .BR ADJ_MAXERROR
>  Set maximum time error from
> 


