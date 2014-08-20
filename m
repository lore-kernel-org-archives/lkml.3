Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaHTJdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:33:24 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42929 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaHTJdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:33:23 -0400
Message-ID: <53F46B5B.80400@collabora.co.uk>
Date: Wed, 20 Aug 2014 11:33:15 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Mark Brown <broonie@kernel.org>
CC: Thierry Reding <treding@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: [PATCH V2] regmap: of_regmap_get_endian() cleanup
References: <1408466947-26593-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1408466947-26593-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On 08/19/2014 06:49 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Commit d647c199510c ("regmap: add DT endianness binding support") had
> some issues. Commit ba1b53feb8ca ("regmap: Fix DT endianess parsing
> logic") fixed the main problem. This patch fixes the other.
> 
> Specifically, restore the overall default of REGMAP_ENDIAN_BIG if none of
> the config, DT, or the bus specify any endianness. Without this,
> of_regmap_get_endian() could return REGMAP_ENDIAN_DEFAULT, which the
> calling code can't handle. Since all busses do specify an endianness in
> the current code, this makes no difference right now, but I saw no
> justification in the patch description for removing this final default.
> 

Yes, I also wondered about the second issue you are mentioning when I was
fixing the main problem. But since Xiubo's patch also set
REGMAP_ENDIAN_BIG as default for both the I2C and SPI buses (making no
difference as you said) I assumed that the intention was to make buses to
explicitly define their default instead of rely on a global one so I just
kept that way.

But I agree with you that is better to go back to the default
REGMAP_ENDIAN_BIG as it used to be before since buses can change the
default if needed anyways.

Best regards,
Javier


