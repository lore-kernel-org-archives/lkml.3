Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab3BTRQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:16:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54822 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700Ab3BTRQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:16:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: Re[12]: [PATCH v3] mfd: syscon: Add non-DT support
Date: Wed, 20 Feb 2013 17:16:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Dong Aisheng <dong.aisheng@linaro.org>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <201302201500.18803.arnd@arndb.de> <1361376371.184258129@f173.mail.ru>
In-Reply-To: <1361376371.184258129@f173.mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302201716.04650.arnd@arndb.de>
X-Provags-ID: V02:K0:bY8uwFDCINduKWmP3JJwGVnFTdDlTl0MuYbPtMP9cUO
 +tYIQ1RfUBU4SudcK2n6NMEE+2B6grIiisoXKMLIiACOpt0YwS
 KYXIabInFAqLphGSN7omBCBB7bgLZN+KiQBKbkPiYOXmCzXFHO
 Vwp9pXuqp3f35fPjWUD4W7WJH22zKT/i2nek40U0EgwR0yxEFs
 tk41Vmai2PgiJirr0z8fQHF3krryRWSR7hsrH8/r8zP/vJaYIa
 B0Tnbp6y4EnyB5oYjPn4d3McUgwKnD7eDILq2Z+pGJYlAvOrHf
 PtktjltxPqqJrGj2CULhIoLH5UfBinIu+BS4e2Wk6UaxA9uBhn
 A5CEo29Z3bxlkop0NJbo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013, Alexander Shiyan wrote:
> No. Target have a three SYSCON registers and two SYSFLG. All these registers
> can be combined into three syscon devices.
> Only these registers will be handled via syscon device, so it is not only one.
> Or you mean about handle all register via syscon? It is not it.

Yes, I was expecting that you would list all three pages in the resource
for the syscon device, basically making all of the core clps711x
registers available this way.

> > treat the absence of DT information as an error, and a call to
> > syscon_regmap_lookup_by_compatible or syscon_regmap_lookup_by_phandle
> > will always return the syscon device that was registered first, or
> > -EPROBE_DEFER for any error.
> 
> The initial idea is search desired syscon device from drivers only by one function
> (i.e. search syscon device by compatible string or by specific alias) and no depend
> on DT or non-DT. I.e. define syscon device always at machine start (even if we run
> machine from DTS), because device should be always present in system.

I don't understand yet what the advantage for clps711x is over just a single
register area that would get registered at boot time and replace all the
clps_readl/clps_writel calls.

	Arnd
