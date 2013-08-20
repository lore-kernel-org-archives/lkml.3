Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab3HTU2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:28:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43288 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab3HTU2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:28:30 -0400
Message-ID: <5213D16C.40304@wwwdotorg.org>
Date: Tue, 20 Aug 2013 14:28:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] pinctrl: tegra: use pinctrl-utils APIs for mapping
References: <1377000758-3795-1-git-send-email-ldewangan@nvidia.com> <1377000758-3795-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1377000758-3795-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 06:12 AM, Laxman Dewangan wrote:
> Pin control utility functions provides the function for creating
> map lists.
> 
> In place of implementing APIs locally in Tegra pin control driver
> for creating map lists, use the utility functions. This reduces
> the code size and avoid duplication.

This patch looks fine, so assuming the issue in patch 1/2 is fixed, this
patch,
Acked-by: Stephen Warren <swarren@nvidia.com>

One thought though:

> diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c

>  static const struct cfg_param {
>  	const char *property;
>  	enum tegra_pinconf_param param;
> @@ -212,12 +112,13 @@ static const struct cfg_param {
>  	{"nvidia,drive-type",		TEGRA_PINCONF_PARAM_DRIVE_TYPE},
>  };

If you add a new field to that struct that's a function pointer, which
parses the content of the property and gives back an unsigned log or
struct pinctrl_map, you could probably make most of
tegra_pinctrl_dt_subnode_to_map() be generic too...

But, that's certainly something for a separate patch if you want.
