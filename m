Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3CLODf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:03:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54622 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3CLODd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:03:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: FW: Regulator API ignored return values
Date: Tue, 12 Mar 2013 14:03:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Chris Ball <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Axel Lin <axel.lin@ingics.com>, Jingoo Han <jg1.han@samsung.com>,
        Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        linux-mmc@vger.kernel.org
References: <25B60CDC2F704E4E9D88FFD52780CB4C0BDEB0547F@SC-VEXCH1.marvell.com> <CADz5_g+KfxL43BKKsgZZ3Xg4sZWE4-ZaFpFhphKrfj9yK59-XA@mail.gmail.com>
In-Reply-To: <CADz5_g+KfxL43BKKsgZZ3Xg4sZWE4-ZaFpFhphKrfj9yK59-XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121403.09315.arnd@arndb.de>
X-Provags-ID: V02:K0:IHF+o8cSb22gyU9nQgwWCwCLcXQLZBi0Gux2NBDT02n
 mRRENR566zzPATOIJqCFan0EZ9UIF9WBra0FaRCofg1wcmW1tq
 qqSwoNVwg0jR2X4o02UcT6zNIzJLfMTZ4S4ZTp6+ALFwo3D9Vy
 tNUKrBkXlTJ1lxFp5VLdOc1YnkLra2U9lJ9MUa1qDmpWAMyM/5
 76g7lztSAp57gBrq3LhPcuh/EQvsfzrS+Ujva3eshrMyVAz7jL
 oBXUOC2NHsf8FLS/6sbKtdQ233C4igDgrDV8V/thnide9Snn8q
 yOtdWBhJMpYKEf4X16oldqumZlypAgaKEXkbpwbvVAgi2v0DWc
 SKQsWVMLW0Vwa4Ue6HEU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 March 2013, Kevin Liu wrote:
> > -               regulator_enable(host->vqmmc);
> > +               ret = regulator_enable(host->vqmmc);
> >                 if (!regulator_is_supported_voltage(host->vqmmc, 1700000,
> >                         1950000))
> >                         caps[1] &= ~(SDHCI_SUPPORT_SDR104 |
> >                                         SDHCI_SUPPORT_SDR50 |
> >                                         SDHCI_SUPPORT_DDR50);
> > +               if (ret) {
> > +                       pr_warn("%s: Failed to enable vqmmc regulator: %d\n",
> > +                               mmc_hostname(mmc), ret);
> 
> Need add regulator_put here since regulator_get has succeed?

Hmm, we still don't actually bail out if the error is encountered, so
the reference count is balanced with the current patch, but I maybe
a failed regulator_enable() should actually be a fatal error?

If we do that, using devm_regulator_get() would be a nice way to
track the reference counts.

	Arnd
