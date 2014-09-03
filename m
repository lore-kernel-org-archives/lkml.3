Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaICNtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:49:42 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60170 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbaICNtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:49:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, Alexander Shiyan <shc_work@mail.ru>,
        naushad@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, joshi@samsung.com,
        linux-samsung-soc@vger.kernel.org, thomas.ab@samsung.com,
        tomasz.figa@gmail.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        lee.jones@linaro.org, Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from platform devices
Date: Wed, 03 Sep 2014 15:49:04 +0200
Message-ID: <4224773.hl3QDeILqz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140903151611.260a7218@bbrezillon>
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com> <6034841.GFrG3XCMdb@wuerfel> <20140903151611.260a7218@bbrezillon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FqGc2/7Ggk0Ab1jXGGfLEDdK9xdc/THeaB5LREAxr4k
 MPDZG1SBSuYLX8Y7Q9PPgLCIOqgDcZufvTzYBuLSJQO/s54HeZ
 CfQx8Y1TVMCAE7D1svUbTf9GP7hlufuuqpfErH2EuU858i/mhC
 O1vR6/gm/fxkzZre7XbGXnXuaaU1HNsvR7ZY3nOAP2Fqv4ih7/
 wDqleoBtI6T2TEn1779k7BvBEVd+7c/0vTlGSWa3a4ILlGcTY3
 o1oDFAvYY1/1cHuzdrsF36FoTUC6SEkZ9826hhTo0LAnfvvCoh
 uTo2mRjWdCcWJMVpIViOhyhlUfEP5WuqmY+tDW4aMSQOUUj31R
 A10jiEp3pKzcjAvUFfiI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2014 15:16:11 Boris BREZILLON wrote:
> I checked that part, and it appears most of the code is already there
> (see usage of regmap_attach_dev function here [1]).
> 
> The only problem I see is that errors are still printed with dev_err,
> which, AFAIK, will trigger a kernel panic if dev is NULL.

Actually not:

static int __dev_printk(const char *level, const struct device *dev,
                        struct va_format *vaf)
{
        if (!dev)
                return printk("%s(NULL device *): %pV", level, vaf);

        return dev_printk_emit(level[1] - '0', dev,
                               "%s %s: %pV",
                               dev_driver_string(dev), dev_name(dev), vaf);
}


	Arnd
