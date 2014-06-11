Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaFKKhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 06:37:53 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:50871 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbaFKKhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 06:37:51 -0400
Message-ID: <1402483068.3798.82.camel@x220>
Subject: Re: [PATCH v3 5/7] mfd: cros_ec: Sync to the latest
 cros_ec_commands.h from EC sources
From: Paul Bolle <pebolle@tiscali.nl>
To: Bill Richardson <wfrichar@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Simon Glass <sjg@chromium.org>,
        Lee Jones <lee.jones@linaro.org>
Cc: swarren@nvidia.com, wsa@the-dreams.de, abrestic@chromium.org,
        dgreid@chromium.org, olof@lixom.net, sameo@linux.intel.com,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jun 2014 12:37:48 +0200
In-Reply-To: <20140520084602.GF24991@lee--X1>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
	 <1398879850-9111-6-git-send-email-dianders@chromium.org>
	 <20140520084602.GF24991@lee--X1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2014 10:37:49.0601 (UTC) FILETIME=[30EA3110:01CF8561]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 09:46 +0100, Lee Jones wrote:
> On Wed, 30 Apr 2014, Doug Anderson wrote:
> > From: Bill Richardson <wfrichar@chromium.org>
> > 
> > This just updates include/linux/mfd/cros_ec_commands.h to match the
> > latest EC version (which is the One True Source for such things).  See
> > <https://chromium.googlesource.com/chromiumos/platform/ec>
> > 
> > [dianders: took today's ToT version from the Chromium OS EC; deleted
> > references to cros_ec_dev and cros_ec_lpc since those aren't upstream
> > yet]
> > 
> > Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > Reviewed-by: Simon Glass <sjg@chromium.org>
> > Tested-by: Andrew Bresticker <abrestic@chromium.org>
> > Tested-by: Stephen Warren <swarren@nvidia.com>
> > ---
> > Changes in v3: None
> > Changes in v2: None
> > 
> >  drivers/mfd/cros_ec.c                |    2 +-
> >  include/linux/mfd/cros_ec.h          |    4 +-
> >  include/linux/mfd/cros_ec_commands.h | 1128 +++++++++++++++++++++++++++++++---
> >  3 files changed, 1059 insertions(+), 75 deletions(-)
> 
> Applied, thanks.

This patch is included in linux-next since next-20140521. I'm not sure
why I waited three weeks before sending this question...

> > [...]
> > diff --git a/include/linux/mfd/cros_ec_commands.h b/include/linux/mfd/cros_ec_commands.h
> > index 86fd069..7853a64 100644
> > --- a/include/linux/mfd/cros_ec_commands.h
> > +++ b/include/linux/mfd/cros_ec_commands.h
>> [...]
> > @@ -1206,14 +1865,231 @@ struct ec_params_force_idle {
> > [...]
> > +/*
> > + * Known param numbers are defined here. Ranges are reserved for board-specific
> > + * params, which are handled by the particular implementations.
> > + */
> > +enum charge_state_params {
> > +	CS_PARAM_CHG_VOLTAGE,	      /* charger voltage limit */
> > +	CS_PARAM_CHG_CURRENT,	      /* charger current limit */
> > +	CS_PARAM_CHG_INPUT_CURRENT,   /* charger input current limit */
> > +	CS_PARAM_CHG_STATUS,	      /* charger-specific status */
> > +	CS_PARAM_CHG_OPTION,	      /* charger-specific options */
> > +	/* How many so far? */
> > +	CS_NUM_BASE_PARAMS,
> > +
> > +	/* Range for CONFIG_CHARGER_PROFILE_OVERRIDE params */

CONFIG_CHARGER_PROFILE_OVERRIDE doesn't match anything in linux-next. Is
a Kconfig symbol CHARGER_PROFILE_OVERRIDE perhaps queued somewhere?

> > +	CS_PARAM_CUSTOM_PROFILE_MIN = 0x10000,
> > +	CS_PARAM_CUSTOM_PROFILE_MAX = 0x1ffff,
> > +

I guess so, because these two constants aren't used anywhere.

> > +	/* Other custom param ranges go here... */
> > +};
> > [...]

Thanks,


Paul Bolle

