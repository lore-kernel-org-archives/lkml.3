Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaIBRlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:41:19 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:56266 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaIBRlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:41:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, Alexander Shiyan <shc_work@mail.ru>
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, naushad@samsung.com,
        lee.jones@linaro.org, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, joshi@samsung.com,
        linux-samsung-soc@vger.kernel.org, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>, vikas.sajjan@samsung.com,
        chow.kim@samsung.com, tomasz.figa@gmail.com,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from platform devices
Date: Tue, 02 Sep 2014 19:40:45 +0200
Message-ID: <3685403.qLrNHfR1Kx@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409672572.303525842@f75.i.mail.ru>
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com> <6034841.GFrG3XCMdb@wuerfel> <1409672572.303525842@f75.i.mail.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VJrIwuWVsoD0EzK8xBerwqogmsPEZkBi5vk/Cy+OlNN
 3DVZHsYR+q33/yORT3dvBIeDQCIzIQC+gqCFnjMsb1Mx9F6sDO
 Z7XxHBl99XfvQ2jJ/rEqLpz95WVbgj9ZbTN5C//U+eCMhRrp80
 ycmq56RJ9FXLaGwexaMj/qMXEy/R2VpO+7+5iOkXPnLW3ptQsB
 hsdxRXrdba+m39rEoqIVekUjaG6Yl3qaDoCZO4cuX+bDmL59Kt
 ev76iPjFTbPZFeaSMh0DxqpOG9wtjaVpuCCKIC4gfF2ICo2cQF
 5zXmHne7kxn0sptnEC4Kqs5yZ4f38RnJ680FNlqk1lBwho057B
 Aezp0eQamksIlRBWm4cE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2014 19:42:52 Alexander Shiyan wrote:
> > > -struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
> > > -{
> > > -   struct device *dev;
> > > -   struct syscon *syscon;
> > > -
> > > -   dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> > > -                            syscon_match_pdevname);
> > > -   if (!dev)
> > > -           return ERR_PTR(-EPROBE_DEFER);
> > > -
> > > -   syscon = dev_get_drvdata(dev);
> > > -
> > > -   return syscon->regmap;
> > > -}
> > > -EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
> > 
> > I think this can actually be left intact if that helps with clps71xx.
> > It could be done in a hacky way using bus_find_device_by_name()
> > to keep it simple, or in a somewhat nicer way by keeping the 
> > syscon platform_driver around for the non-DT case.
> 
> It will not work anyway because the patch involves the use of
> of_device_is_compatible(), of_iomap() etc...

What I meant was to have the pdevname stuff keep working the way
it does today. At that point, you essentially have two completely
independent drivers, one that registers a platform driver and
provides syscon_regmap_lookup_by_pdevname, and one that provides
the other interfaces using DT lookup.

	Arnd
