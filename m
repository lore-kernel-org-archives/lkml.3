Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaBJKxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:53:37 -0500
Received: from smtp-out-245.synserver.de ([212.40.185.245]:1025 "EHLO
	smtp-out-182.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751436AbaBJKxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:53:35 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4750
Message-ID: <52F8AFB2.4000307@metafoo.de>
Date: Mon, 10 Feb 2014 11:53:38 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] regmap: Check readable regs in _regmap_read
References: <73e82a7cf77a1a68c5303def3071418b7d0ea382.1392029156.git.michal.simek@xilinx.com>
In-Reply-To: <73e82a7cf77a1a68c5303def3071418b7d0ea382.1392029156.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 11:46 AM, Michal Simek wrote:
> Check if regs are readable.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>
>   drivers/base/regmap/regmap.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 6a19515..7569dfc 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -1725,6 +1725,9 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
>   	int ret;
>   	void *context = _regmap_map_get_context(map);
>
> +	if (!regmap_readable(map, reg))
> +		return -EIO;
> +

This will cause issues with devices where registers are writable, but not 
readable, but we keep the register value in the cache.

>   	WARN_ON(!map->reg_read);
>
>   	if (!map->cache_bypass) {
> --
> 1.8.2.3
>

