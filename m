Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbaGVSeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:34:09 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:52513 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaGVSeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:34:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        kgene.kim@samsung.com, pawel.moll@arm.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        galak@codeaurora.org, ch.naveen@samsung.com,
        linux-input <linux-input@vger.kernel.org>, heiko.stuebner@bq.com
Subject: Re: [PATCH v2] iio: exynos-adc: add experimental touchscreen support
Date: Tue, 22 Jul 2014 20:33:44 +0200
Message-ID: <5072247.HRN2kuegE2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140722180904.GB5489@core.coreip.homeip.net>
References: <5068889.1KfVx3ksNo@wuerfel> <20140722180904.GB5489@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/OsgU7h6uq7vh8Jbx3F6p6WHRn0heHPJMLvoWUVYsy7
 7eNHtyDa/kVeBj6SPxDclTr3fK07IBXvve6sUdrMG7ZVctsOB3
 m1lrL9xwV9Qwq1lVc9TfrA7n+kd6Ggt7kALrxe39h6BMklBpJU
 9cxjdxyQt//tV11Q7/+TCwp3z278n17bryK8P+KNu//sOQeCjJ
 E49qtuuKvbO6LB6CSWTbhDrG8djTxR+0SWIj6ibOkaAdnpQqh6
 NAao9l/MFtkHFmJb71FM8ps6QqSn/064Dj0q2d0AUSh/ZphWxi
 +4cuB+nHssiD2j9+RZKaoRDk8gpa23mNM1dUxkdaJ1Uk3ar+6e
 6vqsmlCWfTHKwMawQEaA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2014 11:09:04 Dmitry Torokhov wrote:
> > @@ -565,6 +722,15 @@ static int exynos_adc_probe(struct platform_device *pdev)
> >       if (info->data->init_hw)
> >               info->data->init_hw(info);
> >  
> > +     /* leave out any TS related code if unreachable */
> > +     if (IS_BUILTIN(CONFIG_INPUT) ||
> > +         (IS_MODULE(CONFIG_INPUT) && config_enabled(MODULE)))
> 
> This is ugly... We need IS_SUBSYSTEM_AVAILABLE() wrapper for this...
> 
> Anyway,
> 
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> 

I actually have a patch to introduce IS_REACHABLE() for this purpose,
but I haven't sent it out for review yet. The main user of this would
be drivers/media, which had the correct logic earlier until someone
tried to "simplify" it by replacing it all with IS_ENABLED()...

	Arnd
