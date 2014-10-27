Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaJ0RAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:00:55 -0400
Received: from gloria.sntech.de ([95.129.55.99]:52280 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbaJ0RAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:00:53 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: balbi@ti.com
Cc: Romain Perier <romain.perier@gmail.com>, devicetree@vger.kernel.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, robh@kernel.org, mark.rutland@arm.com,
        johan@kernel.org, linux-pm@vger.kernel.org, linux@roeck-us.net,
        lee.jones@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v1 03/10] regulator: act8865: Use of_is_system_power_controller helper function
Date: Mon, 27 Oct 2014 18:03:51 +0100
Message-ID: <7689962.rlsfMIoFoC@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20141027164022.GC14253@saruman>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com> <1414427215-14380-3-git-send-email-romain.perier@gmail.com> <20141027164022.GC14253@saruman>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 27. Oktober 2014, 11:40:22 schrieb Felipe Balbi:
> On Mon, Oct 27, 2014 at 04:26:48PM +0000, Romain Perier wrote:
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > ---
> > 
> >  drivers/regulator/act8865-regulator.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/regulator/act8865-regulator.c
> > b/drivers/regulator/act8865-regulator.c index 76301ed..435aba1 100644
> > --- a/drivers/regulator/act8865-regulator.c
> > +++ b/drivers/regulator/act8865-regulator.c
> > @@ -365,7 +365,7 @@ static int act8865_pmic_probe(struct i2c_client
> > *client,> 
> >  		return ret;
> >  	
> >  	}
> > 
> > -	if (of_system_has_poweroff_source(dev->of_node)) {
> > +	if (of_is_system_power_controller(dev->of_node)) {
> 
> so building this driver is broken until this patch ? not very good
> either.
> 
> Looks to me you should add of_is_system_power_controller without remove
> of_system_has_poweroff_source() until all users of that have been
> converted over.

or alternatively fold this change into patch1 to keep the renaming together
