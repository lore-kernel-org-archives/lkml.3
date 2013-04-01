Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab3DAQtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:49:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40354 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988Ab3DAQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:49:45 -0400
Message-ID: <5159BAA6.50706@wwwdotorg.org>
Date: Mon, 01 Apr 2013 10:49:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com, arnd@arndb.de,
        olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/6] of: Add support for reading a u32 from a multi-value
 property.
References: <1364451049-2981-1-git-send-email-linux@prisktech.co.nz> <1364451049-2981-2-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1364451049-2981-2-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 12:10 AM, Tony Prisk wrote:
> This patch adds an of_property_read_u32_index() function to allow
> reading a single indexed u32 value from a property containing multiple
> u32 values.

> diff --git a/drivers/of/base.c b/drivers/of/base.c

> +int of_property_read_u32_index(const struct device_node *np,

> +	if ((index * sizeof(*out_value)) > prop->length)
> +		return -EOVERFLOW;

I think that if should be:

	if (((index + 1) * sizeof(*out_value)) > prop->length)

since the code should check if the last byte of the u32 is out-of-range,
not whether the first byte is.

Aside from that, this patch,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
