Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaE1UAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:00:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaE1UAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:00:09 -0400
Date: Wed, 28 May 2014 13:03:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-serial@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Jiri Slaby <jslaby@suse.cz>,
        Kumar Gala <galak@kernel.crashing.org>,
        Pantelis Antoniou <panto@intracom.gr>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Joe Schultz <jschultz@xes-inc.com>,
        Loic Poulain <loic.poulain@intel.com>,
        Kyle McMartin <kyle@infradead.org>,
        Stephen Warren <swarren@nvidia.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 1/4] serial: core: Consistent LF handling for
 poll_put_char
Message-ID: <20140528200344.GA2750@kroah.com>
References: <1400079335-32125-1-git-send-email-daniel.thompson@linaro.org>
 <1400079335-32125-2-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400079335-32125-2-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 03:55:32PM +0100, Daniel Thompson wrote:
> The behaviour of the UART poll_put_char infrastructure is inconsistent
> with respect to linefeed conversions. This in turn leads to difficulty
> using kdb on serial ports that are not also consoles
> (e.g. console=ttyAMA0,115200 kgdboc=ttyAMA1,115200).
> 
> The following drivers automatically convert '\n' to '\r\n' inside their
> own poll functions but the remaining seventeen do not:
> 
>     serial8250, cpm, pch_uart, serial_pxa, serial_txx9,
> 
> This can be made fully consistent but performing the conversion in
> uart_poll_put_char(). A similar conversion is already made inside
> uart_console_write() but it is optional for drivers to use this
> function. Fortunately we can be confident the translation is safe
> because the (very common) 8250 already does this translation.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Pantelis Antoniou <panto@intracom.gr>
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Joe Schultz <jschultz@xes-inc.com>
> Cc: Loic Poulain <loic.poulain@intel.com>
> Cc: Kyle McMartin <kyle@infradead.org>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> ---
>  drivers/tty/serial/8250/8250_core.c         | 5 -----

This patch doesn't apply to my tty-next branch anymore, as it seems that
part of it is already there, right?

Can you respin this whole series and resend?

thanks,

greg k-h
