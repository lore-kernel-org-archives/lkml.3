Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaCFR7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:59:49 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57934 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaCFR7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:59:47 -0500
Message-ID: <5318B790.8090808@wwwdotorg.org>
Date: Thu, 06 Mar 2014 10:59:44 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, linux@roeck-us.net
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 3/3] ARM: tegra: dalmore: add thermal zones for nct1008
References: <1393932664-13319-1-git-send-email-wni@nvidia.com> <1393932664-13319-4-git-send-email-wni@nvidia.com>
In-Reply-To: <1393932664-13319-4-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 04:31 AM, Wei Ni wrote:
> Add dt node to describe the thermal zone for the nct1008.

> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts

> +	thermal-zones {
> +		nct1008-local {
> +			polling-delay-passive = <2000>; /* milliseconds */
> +			polling-delay = <0>; /* milliseconds */

A delay of 0 implies that software continually polls this zone, thus
consuming an entire CPU. Is this really what you want?

> +
> +			thermal-sensors = <&nct1008 0>;
> +		};

This zone (and the other) is missing the required (per the binding
documentation) trips and cooling-maps sub-nodes.

I've also sent a query in response to the thermal-zones binding so see
whether or not it can be fixed so that software doesn't bind against the
node name, but rather against a compatible property like almost
everything else. Let's see what the response is there before reposting
this patch.
