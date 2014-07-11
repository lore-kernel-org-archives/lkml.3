Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaGKJwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:52:08 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22902 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaGKJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:52:05 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-db-53bfb3c170fe
Message-id: <53BFB39F.6040606@samsung.com>
Date: Fri, 11 Jul 2014 11:51:27 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Tushar Behera <tushar.b@samsung.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: robh+dt@kernel.org, grant.likely@linaro.org, kgene.kim@samsung.com,
        mturquette@linaro.org, trblinux@gmail.com
Subject: Re: [PATCH 0/2] clk: exynos-audss: Adapt to exising clock framework
References: <1405071475-31946-1-git-send-email-tushar.b@samsung.com>
In-reply-to: <1405071475-31946-1-git-send-email-tushar.b@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xa7oHN+8PNli0W9hi/pFzrBYH/uxg
	tOhdcJXNYtPja6wWl3fNYbOYcX4fk8XTCRfZLFr3HmG32DB5N7vFje1fWRy4PHbOusvusWlV
	J5vHnWt72Dw2L6n36NuyitHj8ya5ALYoLpuU1JzMstQifbsErozZs36zFtxmr7jz5jJjA+Mi
	ti5GDg4JAROJ/3Ozuxg5gUwxiQv31gOFuTiEBJYySkx4uJwFwvnMKLG2YTsrSBWvgJbEyj+/
	2EBsFgFViQWPXjGD2GwCahKfGx6BxfmBatY0XWcBWSAqECHx+IIQRKugxI/J98BmigisZ5Ro
	apsD1sssUCzxdMYURhBbWMBHou/Qa3YQW0jAReLf/W9gezkFXCXu9j9hhajXkdjfOo0NwpaX
	2LzmLfMERsFZSHbMQlI2C0nZAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghMfJlB+Pi
	Y1aHGAU4GJV4eDVqdwcLsSaWFVfmHmKU4GBWEuF9Ur8/WIg3JbGyKrUoP76oNCe1+BAjEwen
	VAPjfJmqNV38G0oZGPp+HdvjNlsrYf/PvqXznCbXzwo4lfmeVdFH7PmdiWtK2Dd/ddDnqNKt
	N9aUPxoq8euxX9qjuII0LR7H9Us8DBt3FWX9O/Pry8Hw0gw380Aumb4f/++90/o6KeP4m30l
	Zte3rnpw0c+wK3Prtbu7nqc9LVklZPQm75XD4WmuSizFGYmGWsxFxYkAyqY1728CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tushar,

On 11.07.2014 11:37, Tushar Behera wrote:
> The patchset is targetted as moving exising exynos-audss clock driver from being
> a module driver. The driver is now registered through CLK_OF_DECLARE and is
> inline with other Samsung clock drivers.

I'm afraid I have to NAK this series or at least the part converting the
driver back to use CLK_OF_DECLARE().

We have deliberately made this driver a platform driver, because this is
how drivers should be modeled in Linux kernel whenever possible.
CLK_OF_DECLARE() should be only considered a hack to work around late
initialization of driver model. Reverting this change without a good
reason (and you haven't provided such) is just going backwards.

Rest of this series is actually quite nice, though, as reusing Samsung
clock helpers reduces the line count significantly, so if you could
rework this to keep this driver a platform driver then we could get
something I could ack.

Best regards,
Tomasz
