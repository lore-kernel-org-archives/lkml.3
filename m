Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaCHUYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 15:24:51 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52615 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbaCHUYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 15:24:50 -0500
X-Sasl-enc: y5FDFaDyh2uEHzg3EZv+s6zC0sKFfn10NE9S25Wiej3W 1394310288
Date: Sat, 8 Mar 2014 12:25:23 -0800
From: Greg Kroah-Hartman <greg@kroah.com>
To: Conrad Meyer <cemeyer@uw.edu>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: Fix 80-char line limit style issue in
 addi_apci_1500.c
Message-ID: <20140308202523.GA11367@kroah.com>
References: <20140308143838.19e2a640@m>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140308143838.19e2a640@m>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 02:38:38PM -0500, Conrad Meyer wrote:
> Fix minor checkpatch.pl style issues (80-char line limits) in
> addi_apci_1500.c.
> 
> Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
> ---
>  drivers/staging/comedi/drivers/addi_apci_1500.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/addi_apci_1500.c b/drivers/staging/comedi/drivers/addi_apci_1500.c
> index 74f7ace..f23ca3d 100644
> --- a/drivers/staging/comedi/drivers/addi_apci_1500.c
> +++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
> @@ -26,11 +26,13 @@ static const struct addi_board apci1500_boardtypes[] = {
>                 .di_read                = i_APCI1500_Initialisation,
>                 .di_write               = i_APCI1500_StartStopInputEvent,
>                 .di_bits                = apci1500_di_insn_bits,
> -               .do_config              = i_APCI1500_ConfigDigitalOutputErrorInterrupt,
> +               .do_config              =
> +                       i_APCI1500_ConfigDigitalOutputErrorInterrupt,

No, as horrible as too long of a line it might be, this is worse.  How
about renaming the function to be more "sane" which would cause it to be
shorter here, fixing the line limit.

Something like config_output() would be better, right?

>                 .do_write               = i_APCI1500_WriteDigitalOutput,
>                 .do_bits                = i_APCI1500_ConfigureInterrupt,
>                 .timer_config           = i_APCI1500_ConfigCounterTimerWatchdog,
> -               .timer_write            = i_APCI1500_StartStopTriggerTimerCounterWatchdog,
> +               .timer_write            =
> +                       i_APCI1500_StartStopTriggerTimerCounterWatchdog,

Same here, "timer_watchdog()"?

thanks,

greg k-h
