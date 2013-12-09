Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab3LIPsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:48:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64311 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab3LIPsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:48:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: boris brezillon <b.brezillon@overkiz.com>
Subject: Re: [PATCH v4 3/6] ARM: at91/dt: define sama5d3 clocks
Date: Mon, 9 Dec 2013 16:48:13 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com> <201312090309.23723.arnd@arndb.de> <52A582AB.6010504@overkiz.com>
In-Reply-To: <52A582AB.6010504@overkiz.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312091648.13802.arnd@arndb.de>
X-Provags-ID: V02:K0:mCqLbTkg+SuEykw+L2YHLy7K4RAN5I1W6IIU4CuAqZi
 L1RsnU3G+ebqPf0c0sR8x1VVdFdaokaTD4J/kubQvgz2HPdstL
 EkKcQVvfJgUL4XBCGcS8C0fuITQqURfrITRBEFH36FrWGW62bM
 iHNZWivhWwsW0sLA8YIWBCvawryrdIBtvZPAQgw+jVqzyhSF8r
 5Wlbpe3ZWP+btAKGy9dZecqF1WAwMgpVbRXn9WMGyqP0quD0cJ
 9YY8nZCy69GoldBXg6iudPnpqFwIXJ9MU+OKk+bKX1hZROVfGR
 ++Nuk0t6/+L6t6ZjWfd/ef7Gb2sIBM9/SrzL3/fQeD8oFEq+Ms
 W5/0OwzcnPMyEsHjG3Fo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 December 2013, boris brezillon wrote:
> > You are adding "clock-names" properties in a lot of cases. Are you sure you
> > are using the strings that are documented in the respective device bindings
> > for each name? In a lot of cases, drivers just want an anonymous clock
> > and we don't name them.
> 
> I rechecked it, and almost all drivers call [devm_]clk_get with a 
> specific clock
> name, and as a result we must specify the "clock-names" property.
> The only exceptions I found are the spi and PIT (Periodic Interval 
> Timer) drivers,
> and "clock-names" property is not defined in these nodes.

Yes, I understood that the *drivers* use the names, but are they actually
documented in the device bindings? If not, it might be better to change the
drivers.

	Arnd
