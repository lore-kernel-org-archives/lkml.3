Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbaGBPzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:55:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54760 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaGBPzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:55:15 -0400
Message-ID: <53B42B60.1000600@wwwdotorg.org>
Date: Wed, 02 Jul 2014 09:55:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
CC: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: tegra: roth: add display DT node
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com> <1404303560-32209-5-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1404303560-32209-5-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 06:19 AM, Alexandre Courbot wrote:
> DSI support has been fixed to support continuous clock behavior that the
> panel used on SHIELD requires, so finally add its device tree node since
> it is functional.

> diff --git a/arch/arm/boot/dts/tegra114-roth.dts b/arch/arm/boot/dts/tegra114-roth.dts

> +	host1x@50000000 {
> +		dsi@54300000 {

That node looks fine, but I wonder why we need to mark a bunch of
regulators as always-on? shouldn't the references to vdd-supply and
power-supply from this node be enough? If not, perhaps the tree
structure of the regulators isn't correct, or the DSI or panel bindings
don't allow enough regulators to be referenced?
