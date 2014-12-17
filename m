Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750899AbaLQPnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:43:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55425 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaLQPnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:43:52 -0500
Message-ID: <5491A501.100@ti.com>
Date: Wed, 17 Dec 2014 17:45:05 +0200
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Nishanth Menon <nm@ti.com>
CC: Lokesh Vutla <lokeshvutla@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] ARM: omap5/dra7xx: Fix counter frequency drift for
 AM572x errata i856.
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca> <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca> <20141214044517.GD24110@csclub.uwaterloo.ca> <549018EC.8020207@ti.com> <20141216145856.GA23358@kahuna> <54918357.8060801@ti.com> <20141217145533.GS24110@csclub.uwaterloo.ca> <20141217152225.GA737@kahuna> <20141217152710.GT24110@csclub.uwaterloo.ca>
In-Reply-To: <20141217152710.GT24110@csclub.uwaterloo.ca>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 05:27 PM, Lennart Sorensen wrote:
> On Wed, Dec 17, 2014 at 09:22:25AM -0600, Nishanth Menon wrote:
>> A clock mux might do the job?
>>
>> value 1, 2 , 3 will imply sysclk1 / 610
>> value of 0 implies fixed 32768
>>
>> soemthing like
>> sys_clk32_crystal {
>>                 compatible = "fixed-clock";
>>                 clock-frequency = <32768>;
>> }
>>
>> sys_clk32_pseudo {
>>                 compatible = "fixed-clock";
>>                 compatible = "fixed-factor-clock";
>>                 clocks = <&sys_clkin1>;
>>                 clock-mult = <1>;
>>                 clock-div = <610>;
>> }
>>
>> sys_32k_ck: sys_32k_ck {
>> 	compatible = "ti,mux-clock";
>> 	clocks = <&sys_clk32_crystal>, <&sys_clk32_pseudo>, <&sys_clk32_pseudo>, <&sys_clk32_pseudo>;
>> };
>>
>> I think... The only issue is that the BOOTSTRAP register is not around
>> the usual CM1,2 address region...
>
> OK, I like where that idea is headed.  That looks promising.
>

Yea clock mux can be used. However, we don't have support for DRA7 
control module clocks in the DT yet. I have posted patches with support 
towards this a couple of weeks back, but they need some revising.

Thus, we maybe need to apply the timer patches as is for now, and fix 
the clock tree a bit later.

-Tero

