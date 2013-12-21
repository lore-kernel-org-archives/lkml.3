Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3LUKwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:52:40 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50855 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3LUKwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:52:39 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 21 Dec 2013 02:52:30 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] drivers: sbe-2t3e3: Mark functions as static in ctrl.c
Message-ID: <20131221105229.GC3611@leaf>
References: <20131221101713.GA3041@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131221101713.GA3041@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 03:47:13PM +0530, Rashika Kheria wrote:
> Mark functions t3e3_set_loopback(), t3e3_reg_read(), t3e3_reg_write(),
> t3e3_port_get(), t3e3_port_set(), t3e3_port_get_stats() and
> t3e3_port_del_stats() as static in ctrl.c because they are not used
> outside this file.
> 
> This eliminates the following warnings in ctrl.c:
> drivers/staging/sbe-2t3e3/ctrl.c:34:6: warning: no previous prototype for ‘t3e3_set_loopback’ [-Wmissing-prototypes]
> drivers/staging/sbe-2t3e3/ctrl.c:98:6: warning: no previous prototype for ‘t3e3_reg_read’ [-Wmissing-prototypes]
> drivers/staging/sbe-2t3e3/ctrl.c:135:6: warning: no previous prototype for ‘t3e3_reg_write’ [-Wmissing-prototypes]
> drivers/staging/sbe-2t3e3/ctrl.c:167:6: warning: no previous prototype for ‘t3e3_port_get’ [-Wmissing-prototypes]
> drivers/staging/sbe-2t3e3/ctrl.c:172:6: warning: no previous prototype for ‘t3e3_port_set’ [-Wmissing-prototypes]
> drivers/staging/sbe-2t3e3/ctrl.c:219:6: warning: no previous prototype for ‘t3e3_port_get_stats’ [-Wmissing-prototypes]
> drivers/staging/sbe-2t3e3/ctrl.c:285:6: warning: no previous prototype for ‘t3e3_port_del_stats’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/sbe-2t3e3/ctrl.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/sbe-2t3e3/ctrl.c b/drivers/staging/sbe-2t3e3/ctrl.c
> index a5825d7..d280bcf 100644
> --- a/drivers/staging/sbe-2t3e3/ctrl.c
> +++ b/drivers/staging/sbe-2t3e3/ctrl.c
> @@ -31,7 +31,7 @@ void t3e3_set_frame_type(struct channel *sc, u32 mode)
>  	sc->p.frame_type = mode;
>  }
>  
> -void t3e3_set_loopback(struct channel *sc, u32 mode)
> +static void t3e3_set_loopback(struct channel *sc, u32 mode)
>  {
>  	u32 tx, rx;
>  
> @@ -95,7 +95,7 @@ void t3e3_set_loopback(struct channel *sc, u32 mode)
>  }
>  
>  
> -void t3e3_reg_read(struct channel *sc, u32 *reg, u32 *val)
> +static void t3e3_reg_read(struct channel *sc, u32 *reg, u32 *val)
>  {
>  	u32 i;
>  
> @@ -132,7 +132,7 @@ void t3e3_reg_read(struct channel *sc, u32 *reg, u32 *val)
>  	}
>  }
>  
> -void t3e3_reg_write(struct channel *sc, u32 *reg)
> +static void t3e3_reg_write(struct channel *sc, u32 *reg)
>  {
>  	u32 i;
>  
> @@ -164,12 +164,12 @@ void t3e3_reg_write(struct channel *sc, u32 *reg)
>  	}
>  }
>  
> -void t3e3_port_get(struct channel *sc, t3e3_param_t *param)
> +static void t3e3_port_get(struct channel *sc, t3e3_param_t *param)
>  {
>  	memcpy(param, &(sc->p), sizeof(t3e3_param_t));
>  }
>  
> -void t3e3_port_set(struct channel *sc, t3e3_param_t *param)
> +static void t3e3_port_set(struct channel *sc, t3e3_param_t *param)
>  {
>  	if (param->frame_mode != 0xff)
>  		cpld_set_frame_mode(sc, param->frame_mode);
> @@ -216,7 +216,7 @@ void t3e3_port_set(struct channel *sc, t3e3_param_t *param)
>  		cpld_set_scrambler(sc, param->scrambler);
>  }
>  
> -void t3e3_port_get_stats(struct channel *sc,
> +static void t3e3_port_get_stats(struct channel *sc,
>  			 t3e3_stats_t *stats)
>  {
>  	u32 result;
> @@ -282,7 +282,7 @@ void t3e3_port_get_stats(struct channel *sc,
>  	memcpy(stats, &(sc->s), sizeof(t3e3_stats_t));
>  }
>  
> -void t3e3_port_del_stats(struct channel *sc)
> +static void t3e3_port_del_stats(struct channel *sc)
>  {
>  	memset(&(sc->s), 0, sizeof(t3e3_stats_t));
>  }
> -- 
> 1.7.9.5
> 
