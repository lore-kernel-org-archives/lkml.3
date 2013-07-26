Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab3GZRgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:36:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42550 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759179Ab3GZRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:36:09 -0400
Message-ID: <51F2B384.9050706@wwwdotorg.org>
Date: Fri, 26 Jul 2013 11:36:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: grant.likely@linaro.org, linus.walleij@linaro.org, rob.herring@calxeda.com,
        rob@landley.net, sameo@linux.intel.com, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, kishon@ti.com,
        swarren@nvidia.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: pinconf_generic: add utility functions for
 add map/configs
References: <1374833754-19659-1-git-send-email-ldewangan@nvidia.com> <1374833754-19659-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1374833754-19659-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 04:15 AM, Laxman Dewangan wrote:
> Some of pincontrol driver needs the utility function to create map
> list. The utility function needed for adding mux, configs etc.

Which other drivers already contain this code? Are you planning on
converting them over to use these new functions? The code looks
familiar, so I assume it's just cut/paste from Tegra with some renames,
so I didn't read it through in detail.

>  drivers/pinctrl/pinconf-generic.c       |  105 +++++++++++++++++++++++++++++++
>  include/linux/pinctrl/pinconf-generic.h |   52 +++++++++++++++

I don't think those are the correct files for this code. Presumably
there's no reason at all why a pinctrl driver that doesn't require
CONFIG_GENERIC_PINCONF can't use these basic utility functions. Perhaps
add a new pinctrl-utils file?
