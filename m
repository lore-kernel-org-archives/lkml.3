Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbaKYOwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:52:47 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39800 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaKYOwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:52:46 -0500
Message-ID: <547497B2.3010907@collabora.co.uk>
Date: Tue, 25 Nov 2014 15:52:34 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Subject: Re: [RFC 0/2] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com> <54736AD0.4070909@collabora.co.uk> <1416907375.5023.54.camel@AMDC1943> <547485F5.50600@collabora.co.uk> <1416925325.26128.6.camel@AMDC1943>
In-Reply-To: <1416925325.26128.6.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 11/25/2014 03:22 PM, Krzysztof Kozlowski wrote:
>> Any ideas?
> 
> Yes, I got. On Peach board the i2s0 is enabled in DTS. Probing it could
> fail because it relies on enabling audss clocks (which cannot be
> accessed).
> 
> I reproduced another hang on Arndale Octa after enabling i2s0 in DTS.
> Maybe that is the cause also on Peach.
> 

You are correct, if I disable i2s0 then I see the logs from
clk_disable_unused_subtree() and boot hangs when accessing the adma clock:

clk: checking dout_fimd1
clk: checking mout_fimd1_final
clk: checking mout_fimd1
clk: checking mout_sclk_rpll
clk: checking fout_rpll
clk: checking adma

With i2s0 disabled, your series are indeed enough to make it boot again but
as you said enabling i2s0 in the DTS makes it hang even with your patches.

Thanks a lot for digging into this!

Best regards,
Javier
