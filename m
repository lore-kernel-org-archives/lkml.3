Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162371AbaDCJDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:03:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40094 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161543AbaDCJDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:03:20 -0400
Date: Thu, 3 Apr 2014 10:02:47 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Antoine =?utf-8?Q?T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] ARM: dts: document the berlin enable-method
 property
Message-ID: <20140403090247.GM16420@e106331-lin.cambridge.arm.com>
References: <1396512496-8030-1-git-send-email-antoine.tenart@free-electrons.com>
 <1396512496-8030-3-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396512496-8030-3-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 09:08:15AM +0100, Antoine Ténart wrote:
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  Documentation/devicetree/bindings/arm/cpus.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index 333f4aea3029..a9e42a2dbc99 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -185,6 +185,8 @@ nodes to be present and contain the properties described below.
>  			    "qcom,gcc-msm8660"
>  			    "qcom,kpss-acc-v1"
>  			    "qcom,kpss-acc-v2"
> +			    "marvell,88de31-smp" - cpu-core handling for Berlin
> +					SoC from Marvell starting with 88de31

It would probably be best to add an enable-method directory and document
what each of these mean (what's expected of the platform, what steps an
OS should make to bring up and/or tear down CPUs).

While it's nice to factor this out of the kernel, I'd like this to be
better-defined such that it's clear what the expectations of each
enable-method are. That ways it iss possible for OSs other than Linux to
make use of the enable-method information (as it won't be an opaque
reference to Linux internals), and we can have a clear definition of
each enable-method independent of any implementation details.

Going forward I would like to see fewer implementation-specific
protocols for bringing up secondaries, and a move to fewer more
standardised mechanisms like PSCI. I realise that might not be possible
in all cases, but it would be nice to avoid a proliferation of
enable-methods with single users.

Cheers,
Mark.
