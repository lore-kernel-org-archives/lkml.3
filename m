Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344AbaH0QkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:40:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60513 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbaH0QkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:40:04 -0400
Message-ID: <53FE09E2.5080708@wwwdotorg.org>
Date: Wed, 27 Aug 2014 10:40:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Warren <swarren@nvidia.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] regmap: Split regmap_get_endian() in two functions
References: <1409150163-25729-1-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1409150163-25729-1-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 08:36 AM, Geert Uytterhoeven wrote:
> Split regmap_get_endian() in two functions, regmap_get_reg_endian() and
> regmap_get_val_endian().
>
> This allows to:
>    - Get rid of the three switch()es on "type", incl. error handling in
>      three "default" cases,
>    - Get rid of the regmap_endian_type enum,
>    - Get rid of the non-NULL check of "config" (regmap_init() already
>      checks for that),
>    - Get rid of the "endian" output parameters, and just return the
>      regmap_endian enum value, as the functions can no longer fail.
>
> This saves 21 lines of code (despite the still-present
> one-comment-per-line over-documentation), and 30 bytes of code on ARM
> V7.

For the mailing list record only (since it's been applied),
Reviewed-by: Stephen Warren <swarren@nvidia.com>
