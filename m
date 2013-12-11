Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab3LKHzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:55:53 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2205 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3LKHzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:55:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 10 Dec 2013 23:52:24 -0800
Message-ID: <52A81A85.9010508@nvidia.com>
Date: Tue, 10 Dec 2013 23:55:49 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Mikko Perttunen <mperttunen@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] gpu: host1x: clk_round_rate() can return a zero upon
 error
References: <alpine.DEB.2.02.1312091746400.4127@tamien> <20131211075117.GA24559@pengutronix.de>
In-Reply-To: <20131211075117.GA24559@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 11:51 PM, Sascha Hauer wrote:
> On Mon, Dec 09, 2013 at 06:00:12PM -0800, Paul Walmsley wrote:
>> Treat both negative and zero return values from clk_round_rate() as
>> errors.  This is needed since subsequent patches will convert
>> clk_round_rate()'s return value to be an unsigned type, rather than a
>> signed type, since some clock sources can generate rates higher than
>> (2^31)-1 Hz.
>>
>> Eventually, when calling clk_round_rate(), only a return value of zero
>> will be considered a error.  All other values will be considered valid
>> rates.  The comparison against values less than 0 is kept to preserve
>> the correct behavior in the meantime.
> Shouldn't it be an error when the result is not within sensible limits
> instead? What do you do with a rate of 1Hz?

It's up to the caller of clk_round_rate() to decide what doesn't make 
sense for its use-case.  The caller can certainly react to non-zero 
rates as it likes.

The 0 return code (and the previous negative return values that were 
used previously) are just intended for the clock framework to signal 
explicit errors encountered during clk_round_rate()'s execution.

- Paul
