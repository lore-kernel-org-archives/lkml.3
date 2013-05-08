Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3EHMMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:12:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3EHMMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:12:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH v2] thermal: cpu_cooling: fix stub function
Date: Wed, 8 May 2013 14:12:13 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <201305021829.37343.arnd@arndb.de> <51829A45.7040307@ti.com>
In-Reply-To: <51829A45.7040307@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305081412.14201.arnd@arndb.de>
X-Provags-ID: V02:K0:ljBbV7rc19IQE9Y9+d+blbKUumOrHzvaqfzxIandEbd
 hIdmpElqT3MjOH1yCYl/rHBDXn1vx3p1snHxnQxSu0LD95Map3
 z5Twh5RP5FwkeH9sBeUNwP0/LRMqNqZe14XEaHoAaTKpNlfyBR
 q8Bynj9V+cIQCK3jXHoYg1fU0fGurAzDtCM2lZB6E4dHlHAswU
 8JVw/HOSTZb31yC0vqR3DzYMmiLS6E+CNO2duSUUN6U246DQEv
 6Cg4EdfP2KWwfuHVZdFmQZMFyLY0pq3puDYgt6oqESkMDqnEXb
 /Q7GWWRj+nmeNzbHCIOHa9V5IIo6ZIvtV1H0DL07dvwGMhqeSH
 kp7RYm29fAHdqqrVOHNU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Eduardo Valentin wrote:
> Rui, Arnd,
> 
> On 02-05-2013 12:29, Arnd Bergmann wrote:
> > The function stub for cpufreq_cooling_get_level introduced
> > in 57df81069 "Thermal: exynos: fix cooling state translation"
> > is not syntactically correct C and needs to be fixed to avoid
> > this error:
> > 
> > In file included from drivers/thermal/db8500_thermal.c:20:0:
> >  include/linux/cpu_cooling.h: In function 'cpufreq_cooling_get_level':
> > include/linux/cpu_cooling.h:57:1:
> >  error: parameter name omitted  unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int)  ^
> >  include/linux/cpu_cooling.h:57:1: error: parameter name omitted
> > 
> > Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Amit Daniel kachhap <amit.daniel@samsung.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

Rui,

Could you please merge that into your thermal/next tree?  Right now,
linux-next fails to build because of this, and you probably don't
want to send the current version to Linus without fixing it.

	Arnd
