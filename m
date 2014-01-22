Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbaAVPr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:47:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbaAVPrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:47:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Mark Rutland <mark.rutland@arm.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro CLOCKSOURCE_ACPI_DECLARE
Date: Wed, 22 Jan 2014 16:47:28 +0100
Message-ID: <4603592.X6dscGmyfO@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140122151749.GA1519@e106331-lin.cambridge.arm.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <3140612.0s75qS6VKb@wuerfel> <20140122151749.GA1519@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5OrEmqyo9Vvv75O4oRDKxVYkMJwPLj2n9FrsxYWzqBW
 3pQB2Wzqk9nSGxBMspWh06op7q22h78SPLi1bGlAb36sVqg9tW
 vxMTOwh1xwDUxVA/EzwkfakSj1SoNyk7yTntX10KeN4AHeSp+S
 C40oXiA3qWKkwIBygavXvrB/rlWNRu/2nCSIVLUGqa6WydZVOM
 FGV+0KAZc4aMDTsq7ZSAua4H6err05t+WFCJnm/mxhHXtbDezs
 50il2ur/0792FC85W622q6qQV74THp48ncMOKiTWxpW6qZleRe
 UjIAXhLZMjTyA9WH6S1gFeZq54YMXt2VDBVusuLs8a5nYsH8Df
 vUFzgIa0Ke8f5DkE3lZ8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 January 2014 15:17:49 Mark Rutland wrote:
> Except for the fact that some timers / clocksources that we already have
> in 32-bit land will likely be reused in 64-bit SoC designs. People will
> want to use the same driver for both 32-bit and 64-bit kernels, and thus
> we need CLOCKSOURCE_OF_DECLARE in 64-bit kernels.
> 
> Those platforms which will have ACPI will likely reuse existing timer IP
> blocks, and will want to make minimal changes to the driver, which will
> likely be using CLOCKSOURCE_OF_DECLARE. We can't change these to
> platform drivers or we can break existing systems because the timers
> will be registered too late.
> 
> I don't see how we can share drivers between 32-bit and 64-bit kernels
> without sharing a common driver model, and I think it makes sense to
> have some uniformity across drivers (i.e. always use
> CLOCKSOURCE_*_DECLARE rather than sometimes using platform drivers).

This still sounds like speculation. I would defer this change until
we actually have a platform that needs it.

The platforms that would reuse a lot of IP blocks are most likely
embedded systems and /not/ server hardware following some strict
specification, so they wouldn't use ACPI.

	Arnd
