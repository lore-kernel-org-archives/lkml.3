Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaEHQTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:19:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47582 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767AbaEHQTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:19:18 -0400
Date: Thu, 8 May 2014 17:19:14 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regulator: arizona-ldo1: add missing #include
Message-ID: <20140508161914.GC25203@opensource.wolfsonmicro.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-1-git-send-email-arnd@arndb.de> <1399560990-1402858-19-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399560990-1402858-19-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 04:56:30PM +0200, Arnd Bergmann wrote:
> commit 2cce4be9e6b8 "regulator: arizona-ldo1: Add processing of init_data
> from device tree" added a call to of_get_child_by_name() but
> did not add an #include to the header file declaring that function.
> 
> I got a build error when doing randconfig testing on this, which
> is fixed by this patch to include of.h.
> 
> drivers/regulator/arizona-ldo1.c:192:2: error: implicit declaration of function 'of_get_child_by_name' [-Werror=implicit-function-declaration]
> drivers/regulator/arizona-ldo1.c:193:2: error: implicit declaration of function 'of_parse_phandle' [-Werror=implicit-function-declaration]
> drivers/regulator/arizona-ldo1.c:213:2: error: implicit declaration of function 'of_node_put' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> Cc: Mark Brown <broonie@linaro.org>
> ---

Thanks, yeah seems that is getting implicitly through another
header included in my config. Will need a similar fix for
arizona-micsupp, I will get one out for that.

Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
