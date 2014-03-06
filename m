Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaCFNr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:47:27 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:39609 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbaCFNrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:47:25 -0500
Message-ID: <53187C13.3040202@st.com>
Date: Thu, 6 Mar 2014 14:45:55 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Cc: <mark.rutland@arm.com>, <mturquette@linaro.org>,
        <gregkh@linuxfoundation.org>, <t.figa@samsung.com>,
        <sw0312.kim@samsung.com>, <linux-kernel@vger.kernel.org>,
        <kyungmin.park@samsung.com>, <robh+dt@kernel.org>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>, <m.szyprowski@samsung.com>
Subject: Re: [RFC PATCH v2 0/2] clk: Support for DT assigned clock parents
 and rates
References: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

	I like the principle of your implementation, but I have two questions:
	1 - How can we manage PM with this solution, as the parent/rate will be 
set only once at probe time?
	2 - How to set the parent of a parent clock (which can be shared with 
other devices)? Same question about the parent rates.


Thanks,
Maxime

On 03/03/2014 07:15 PM, Sylwester Nawrocki wrote:
> This patch set adds a DT binding documentation for new 'clock-parents'
> and 'clock-rates' DT properties and a helper function to parse them.
> The helper is now being called from within the driver core, similarly
> as it is done for the pins configuration binding to a device.
>
> Patch 1/2 adds a variant of of_clk_get() function which accepts name of
> a DT property containing list of phandle + clock specifier pairs, as
> opposed to hard coded "clocks" property name in of_clk_get().
> As Mike suggested I've renamed this function to of_clk_get_by_property().
>
> Patch 2/2 actually adds the code searching for related DT properties at
> device node and performing re-parenting and/or clock frequency setting
> as specified.
>
> Changes since v1:
>   - updated DT binding documentation,
>   - dropped the platform bus notifier, the clock setup routine is now
>     being called directly from the driver core before a driver probe() call;
>     this has an advantage such as all bus types are handled and any errors
>     are propagated, so that, for instance a driver probe() can be deferred
>     also when resources specified by clock-parents/clock-rates properties
>     are not yet available; an alternative would be to let drivers call
>     of_clk_device_setup() directly,
>   - dropped the patch adding a macro definition for maximum DT property
>     name length for now.
>
> Open issues:
>   - handling of errors from of_clk_get_by_property() could be improved,
>     currently ENOENT is returned by this function not only for a null
>     entry.
>
> This series has been tested on ARM, on Exynos4412 Trats2 board.
> RFC v1 can be found at:
> http://www.spinics.net/lists/arm-kernel/msg309241.html
>
> Sylwester Nawrocki (2):
>    clk: Add function parsing arbitrary clock list DT property
>    clk: Add handling of clk parent and rate assigned from DT
>
>   .../devicetree/bindings/clock/clock-bindings.txt   |   23 ++++++
>   drivers/base/dd.c                                  |    5 ++
>   drivers/clk/clk.c                                  |   77 ++++++++++++++++++++
>   drivers/clk/clk.h                                  |    3 +
>   drivers/clk/clkdev.c                               |   25 ++++++-
>   include/linux/clk-provider.h                       |    6 ++
>   6 files changed, 135 insertions(+), 4 deletions(-)
>
> --
> 1.7.9.5
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
