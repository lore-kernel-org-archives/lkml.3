Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaENOGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:06:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54972 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaENOGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:06:35 -0400
Date: Wed, 14 May 2014 15:06:29 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Chander Kashyap <k.chander@samsung.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>
Subject: Re: [PATCH v5 4/6] driver: cpuidle: cpuidle-big-little: init driver
 for Exynos5420
Message-ID: <20140514140628.GA25241@e102568-lin.cambridge.arm.com>
References: <ANuQgHGSPJ45tbrVppAVpOqF0OfHacPWfX=S5mOVxTPr66f7vg@mail.gmail.com>
 <1400054637-21505-1-git-send-email-chander.kashyap@linaro.org>
 <1400054637-21505-5-git-send-email-chander.kashyap@linaro.org>
 <5587958.90ud9NuKXm@wuerfel>
MIME-Version: 1.0
In-Reply-To: <5587958.90ud9NuKXm@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 May 2014 14:06:42.0151 (UTC) FILETIME=[BB548F70:01CF6F7D]
X-MC-Unique: 114051415063315101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 02:04:51PM +0100, Arnd Bergmann wrote:
> On Wednesday 14 May 2014 13:33:55 Chander Kashyap wrote:
> > 
> > diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
> > index 4cd02bd..344d79fa 100644
> > --- a/drivers/cpuidle/cpuidle-big_little.c
> > +++ b/drivers/cpuidle/cpuidle-big_little.c
> > @@ -165,6 +165,7 @@ static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int cpu_id)
> >  
> >  static const struct of_device_id compatible_machine_match[] = {
> >         { .compatible = "arm,vexpress,v2p-ca15_a7" },
> > +       { .compatible = "samsung,exynos5420" },
> >         {},
> >  };
> 
> Does the cpuidle-big_little driver actually care about the platform?

No, platform specific bits are hidden behind MCPM. Apart from idle states
data, that will soon be initialized through DT too.

Actually, when idle for arm64 is merged we can even rework it and end up
with a single driver, DT based, that's the ultimate goal.

> If not, it would be good to add a generic string here as well, for
> future platforms to match.

Yes, you have a point.

> It still makes sense to list both the generic string and the platform
> specific one though, in case we have to work around subtle differences.

Agreed, but subtle differences do not belong in this driver, that's the
purpose of abstracting it the best we can. I have no problem in leaving
platform specific compatible there though.

Lorenzo

> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

