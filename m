Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaGNL53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:57:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51755 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbaGNL5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:57:22 -0400
Date: Mon, 14 Jul 2014 12:57:18 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@kernel.org, milo.kim@ti.com, support.opensource@diasemi.com,
        patches@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: drivers: fix return value of get_mode
	callback
Message-ID: <20140714115718.GA18724@opensource.wolfsonmicro.com>
References: <1405333997-28764-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405333997-28764-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 04:03:17PM +0530, Laxman Dewangan wrote:
> The function get_mode() should return 0 on error and REGULATOR_MODE_*
> on success. The return type of this function is defined as unsigned int.
> 
> Some of driver who implements this callback return -ve error number when
> it fails which is incorrect as per function definitions. Correcting the
> implemnetation on different drivers to return 0 (zero) on error and
> REGULATOR_MODE_* on success.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/regulator/ab8500-ext.c         | 4 ++--
>  drivers/regulator/ab8500.c             | 4 ++--
>  drivers/regulator/as3711-regulator.c   | 4 ++--
>  drivers/regulator/as3722-regulator.c   | 4 ++--
>  drivers/regulator/da9055-regulator.c   | 4 ++--
>  drivers/regulator/da9063-regulator.c   | 2 +-
>  drivers/regulator/fan53555.c           | 2 +-
>  drivers/regulator/lp872x.c             | 4 ++--
>  drivers/regulator/lp8788-buck.c        | 2 +-
>  drivers/regulator/max8649.c            | 2 +-
>  drivers/regulator/max8973-regulator.c  | 2 +-
>  drivers/regulator/mc13892-regulator.c  | 2 +-
>  drivers/regulator/tps62360-regulator.c | 2 +-
>  drivers/regulator/tps65910-regulator.c | 4 ++--
>  drivers/regulator/tps65912-regulator.c | 2 +-
>  drivers/regulator/wm831x-dcdc.c        | 4 ++--
>  drivers/regulator/wm831x-ldo.c         | 8 ++++----
>  drivers/regulator/wm8350-regulator.c   | 2 +-
>  18 files changed, 29 insertions(+), 29 deletions(-)

Looks like _regulator_get_mode in core.c would need updated too.
I can't help but wonder if it might be better to just make
get/set mode use an int instead, although I don't know for what
reasons an unsigned int was choosen in the first place so I might
be missing something.

Thanks,
Charles
