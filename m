Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427AbaDJHhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:37:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51632 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965097AbaDJHhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:37:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, andrew@lunn.ch, linux-doc@vger.kernel.org,
        thierry.reding@gmail.com, heiko.stuebner@bq.com,
        linux@arm.linux.org.uk, daniel.lezcano@linaro.org,
        florian.vaussard@epfl.ch, sebastian.hesselbarth@gmail.com,
        devicetree@vger.kernel.org, jason@lakedaemon.net, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org, tglx@linutronix.de,
        rdunlap@infradead.org, silvio.fricke@gmail.com, galak@codeaurora.org,
        olof@lixom.net, jic23@kernel.org, rmk+kernel@arm.linux.org.uk
Subject: Re: [PATCH 3/4] arm: add basic support for Mediatek MT6589 boards
Date: Thu, 10 Apr 2014 09:36:40 +0200
Message-ID: <4752537.la6uZladzC@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1397072736-10793-4-git-send-email-matthias.bgg@gmail.com>
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com> <1397072736-10793-4-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NZrQ6QbPa5R5x9Qz5hYTx9SL0B1FbQWs17R83Bcwq5U
 TAfiPTdzqQSYm2VD8kkbbzRInOGRel9uSnqjNM073YTimPpBBE
 IbmgZKp/0Aau6kUjPHwcSkv6cOXlOQ60f/Zg6hjuAuOkqPj/3Y
 SMKxhlqxxYL1PUU1FoKkaujLDYQ9UZZoV+XvxFsmnHY4V0NvzS
 0j/RgUV6Wd8qTAmBmOiPVcgKjr88qu7DXdEVre3Ix+U3/GsDHY
 QwWrsi4iMJ9gz866L8CCLxgDiJjbQldCRrO/BxANuZlwXdoIGF
 mWDaWmbzIBRYp9s+IRAfDAQTzNE7vyhIqBmG74nKq8t86uy4lp
 LOFSIGmNYyKsRY8liAdI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 April 2014 21:45:35 Matthias Brugger wrote:
> This adds a generic devicetree board file and a dtsi for boards
> based on the MT6589 SoCs from Mediatek.
> 
> Apart from the generic parts (gic, clocks) the only component
> currently supported are the timers.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

Hi Matthias,

First of all, I'm really glad to see this get started, thanks for looking
into these!

Do you know how similar the MT6589 is to the later chips like MT65x2
and MT6588? What are the on-chip devices like, is it mostly licensed
IP blocks from designware and others that we already have drivers for,
or all new drivers?

> +#include <asm/hardware/cache-l2x0.h>
> +
> +static void __init mediatek_dt_init(void)
> +{
> +	l2x0_of_init(0, ~0);
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +}

I hope that with all the cleanup work that Russell has done in the
past few weeks, we can manage to kill off the call to l2x0_of_init()
here and have it done by core architecture code instead. That would
let you have an empty machine file, unless you have other things you
will need to add in the future.

	Arnd
