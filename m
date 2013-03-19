Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab3CSPo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:44:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41162 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab3CSPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:44:27 -0400
Message-ID: <514887D8.2020606@wwwdotorg.org>
Date: Tue, 19 Mar 2013 09:44:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: sameo@linux.intel.com, swarren@nvidia.com,
        broonie@opensource.wolfsonmicro.com, gg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: palmas: initialise client->of_node for dummy created
 client
References: <1363683500-24891-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363683500-24891-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 02:58 AM, Laxman Dewangan wrote:
> Palmas device have three different i2c addresses. The device creates
> the two new dummy i2c clients for accessing the register by using
> primary client adapter. This new dummy i2c client have their of_node
> as NULL.
> 
> The dummy i2c client is used for registering interrupt and on this,
> it creates irq domain handle. This created irq domain handle has
> their of_node as NULL.

It seems like part of the solution here is to modify the i2c_client
object itself so that it can directly support devices that have multiple
I2C addresses; instead of 1 i2c_client representing 1 address, 1
i2c_client could represent a list of addresses, that list being
populated directly from the list contained in the top-level node's reg
property. That way, you wouldn't need any dummy i2c_clients, which would
avoid this issue.

If the I2C device itself has multiple I2C addresses, they really should
all be explicitly listed in the device tree reg property.
