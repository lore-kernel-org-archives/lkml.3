Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaCHLYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 06:24:46 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:44303 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaCHLYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 06:24:43 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2] dt: platform driver: Fill the resources before probe and defer if needed
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, gregkh@linuxfoundation.org,
        robh+dt@kernel.org
Cc: gregory.clement@free-electrons.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
In-Reply-To: <1392988720-20976-1-git-send-email-jjhiblot@traphandler.com>
References: <20140220153042.DF053C4050F@trevor.secretlab.ca> < 1392988720-20976-1-git-send-email-jjhiblot@traphandler.com>
Date: Sat, 08 Mar 2014 07:37:58 +0000
Message-Id: <20140308073758.DA63FC408EC@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 14:18:40 +0100, Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:
> The goal of this patch is to allow drivers to be probed even if at the time of
> the DT parsing some of their ressources are not available yet.

Hi Jean-Jacques

[...]
> +int of_platform_device_prepare(struct platform_device *dev)
> +{
> +	struct device_node *np;
> +	int i, irq_index;
> +	struct resource *res;
> +
> +	/*
> +	 * This function applies only devices described in the DT.
> +	 * Other platform devices have their ressources already populated.
> +	 */
> +	np = dev->dev.of_node;
> +	if (!np)
> +		return 0;

I believe we already talked about the above test. This function must
only process devices created by of_platform_populate(). Merely checking
the of_node pointer is not a sufficient test because there are other
paths in the kernel for creating platform_devices that might get a node
pointer attached to it.

g.

