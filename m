Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab3BWQzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 11:55:51 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60198 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3BWQzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 11:55:50 -0500
Date: Sat, 23 Feb 2013 18:55:45 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Mack <zonque@gmail.com>
Subject: Re: [PATCH 4/5] W1: w1-gpio - rework handling of platform data
Message-ID: <20130223165544.GA11587@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel Mack <zonque@gmail.com>
References: <1361606320-4479-1-git-send-email-dmitry.torokhov@gmail.com>
 <1361606320-4479-4-git-send-email-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1361606320-4479-4-git-send-email-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 11:58:39PM -0800, Dmitry Torokhov wrote:
> The platform data in the dveice structure does not belong to the driver
> and so it should not be trying to alter it, but instead use a local pointer
> and populate it with a local copy in case we are dealing with device tree
> setup.
> 
> Also allow mixed setups where platform data coexists with device tree and
> prefer kernel-supplied data (it may be easier to fiddle in kernel structure
> before committing final result to device tree).
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/w1/masters/w1-gpio.c | 93 +++++++++++++++++++++++++-------------------
>  1 file changed, 53 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
> index aa97a96..ee6b6e3 100644
> --- a/drivers/w1/masters/w1-gpio.c
> +++ b/drivers/w1/masters/w1-gpio.c
> @@ -23,28 +23,33 @@
>  #include "../w1.h"
>  #include "../w1_int.h"
>  
> +struct w1_gpio {
> +	struct w1_bus_master master;
> +	const struct w1_gpio_platform_data *pdata;
> +};

I don't understand why you need this wrapper struct. It doesn't
seem to serve much purpose, other than to cause code churn in
the patch.

But feel free to ignore me if you think it's useful. get_maintainer.pl
doesn't even list me anymore, and that's a good thing since I haven't
even used this driver in years.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
