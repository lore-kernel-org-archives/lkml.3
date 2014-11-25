Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaKYOzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:55:00 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36410 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaKYOy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:54:56 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-d5-5474983d36a3
Message-id: <1416927292.26128.8.camel@AMDC1943>
Subject: Re: [RFC 0/2] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Date: Tue, 25 Nov 2014 15:54:52 +0100
In-reply-to: <547497B2.3010907@collabora.co.uk>
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
 <54736AD0.4070909@collabora.co.uk> <1416907375.5023.54.camel@AMDC1943>
 <547485F5.50600@collabora.co.uk> <1416925325.26128.6.camel@AMDC1943>
 <547497B2.3010907@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xa7q2M0pCDNr2m1u0XTnIbnH0d4FF
	/+PXzBZPNz9mstj0+BqrxeVdc9gsZpzfx2TxdMJFNovDb9pZLVbt+sPowOXx9/l1Fo+ds+6y
	e2xa1cnmcefaHjaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj1OOV7AU7OCv6P9s1
	MK5h72Lk4JAQMJFou1HWxcgJZIpJXLi3nq2LkYtDSGApo8TJJeeYIZzPjBKbFr9lAaniFdCX
	uDjjFTOILSzgL7Fp4jywOJuAscTm5UvYQGwRATuJG6sfgjUzC9xgknhw6TArSIJFQFXi6tLj
	YEWcQIM2Pf4HteE3o8SGf21gCWYBdYlJ8xYxQ5ynLNHY7waxWFDix+R7LBAl8hKb17xlnsAo
	MAtJxywkZbOQlC1gZF7FKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERITX3YwLj5mdYhRgINR
	iYfXILEkRIg1say4MvcQowQHs5IIb1AvUIg3JbGyKrUoP76oNCe1+BAjEwenVANjcCvP5eKt
	r8y/zDu9dZ7E9Ppjp/8eNpqqlfOIhTNPJ+rpgQu5VvN6rZ7tnq9iaeX/8Ga4kbFeOseDSxeK
	u16Kb0kL4y9iYj+ZYMgveJs54cH/widb5eQ0q2IMvBnsWu10tj8skpy3XunIvwsiwW0cTz/y
	2lVoe7/y26247OTarT9mqUVJcAQosRRnJBpqMRcVJwIA9Ho/t2cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-25 at 15:52 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 11/25/2014 03:22 PM, Krzysztof Kozlowski wrote:
> >> Any ideas?
> > 
> > Yes, I got. On Peach board the i2s0 is enabled in DTS. Probing it could
> > fail because it relies on enabling audss clocks (which cannot be
> > accessed).
> > 
> > I reproduced another hang on Arndale Octa after enabling i2s0 in DTS.
> > Maybe that is the cause also on Peach.
> > 
> 
> You are correct, if I disable i2s0 then I see the logs from
> clk_disable_unused_subtree() and boot hangs when accessing the adma clock:
> 
> clk: checking dout_fimd1
> clk: checking mout_fimd1_final
> clk: checking mout_fimd1
> clk: checking mout_sclk_rpll
> clk: checking fout_rpll
> clk: checking adma
> 
> With i2s0 disabled, your series are indeed enough to make it boot again but
> as you said enabling i2s0 in the DTS makes it hang even with your patches.
> 
> Thanks a lot for digging into this!

My patch only fixed the gate clocks but it didn't touched div and mux.
I'll prepare a v2 of it (I got some feedback) which I hope will fix both
cases: i2s and disabling unused clocks.

Best regards,
Krzysztof


