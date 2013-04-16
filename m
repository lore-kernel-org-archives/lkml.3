Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3DPSpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:45:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50272 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab3DPSpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:45:03 -0400
Message-ID: <516D9C2B.302@wwwdotorg.org>
Date: Tue, 16 Apr 2013 12:44:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, gg@slimlogic.co.uk, ian@slimlogic.co.uk,
        j-keerthy@ti.com, t-kristo@ti.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, swarren@nvidia.com
Subject: Re: [PATCH V2] gpio: palmas: add dt support
References: <1366122705-3579-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1366122705-3579-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 08:31 AM, Laxman Dewangan wrote:
> Add of_device_id table for Palma GPIO to be enable the
> driver from DT file.
> 
> The driver can be registered from DT file as:
> 	palmas: tps65913@58 {
> 		:::::::::::
> 		palmas_gpio: palmas_gpio {
> 			compatible = "ti,palmas-gpio";
> 			gpio-controller;
> 			#gpio-cells = <2>;
> 		};
> 	};

So I think this patch looks fine if everyone is agreed that all the
Palmas sub-modules are represented as explicit child nodes in DT, and
the probing of the child nodes is based on the top-level Palmas device
being a bus, and enumerating its children in standard DT style, using
compatible values. (I'm not sure how the child probing/instantiation
will work for non-DT systems though).

I'm not 100% sure if an agreement on the top-level structure of the
Palmas DT bindings was reached though? Can the SlimLogic people confirm
this? I assume Laxman must be OK with it since he's sending this patch?

It might be a good idea to get the final Palmas binding documentation
reviewed and checked in before changing the drivers/.dts files to match
what the final bindings might be.
