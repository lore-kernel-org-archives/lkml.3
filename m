Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaHTUTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:19:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43250 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaHTUTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:19:15 -0400
Message-ID: <53F502D7.9030403@wwwdotorg.org>
Date: Wed, 20 Aug 2014 14:19:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com
Subject: Re: [PATCH v2 2/5] of: Add nvidia,controller-id property to Tegra
 I2C bindings
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com> <1407933685-12404-3-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1407933685-12404-3-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 06:41 AM, Mikko Perttunen wrote:
> Sometimes, hardware blocks want to issue requests to devices
> connected to I2C buses by itself. In such case, the bus the
> target device resides on must be configured into a register.
> For this purpose, each I2C controller has a defined ID known
> by the hardware. Add a property for these IDs to the device tree
> bindings, so that drivers can know what ID to write to a hardware
> register when configuring a block that sends I2C messages autonomously.

> diff --git a/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.txt b/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.txt

> +Optional properties:
> +- nvidia,controller-id: ID of controller when referred to in
> +                        hardware registers.

I'd prefer to put this information into the thermal trip node, since 
this represents what ID the PMC uses to communicate with the I2C 
controller, and there's no absolute guarantee that multiple clients that 
communicate directly with an I2C controller would use the same numbering 
scheme.

If that doesn't work, can be at least name this nvidia,pmc-controller-id 
or nvidia,id-in-pmc so that if there are different numbering schemes, 
there's a clear path to represent this in different properties without 
conflicting names?
